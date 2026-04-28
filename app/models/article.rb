class Article < ApplicationRecord
  include Post
  include Featureable
  include Translatable

  has_one  :redirect, dependent: :destroy
  has_many :taggings, dependent: :destroy, as: :taggable
  has_many :tags, through: :taggings
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations

  # Collections / Nested Articles, used for live blogs
  has_many :collection_posts,
           foreign_key: :collection_id,
           class_name:  'Article',
           inverse_of:  :collection,
           dependent:   :destroy

  belongs_to :collection,
             class_name: 'Article',
             inverse_of: :collection_posts,
             touch:      true,
             optional:   true

  before_validation :generate_published_dates, on: %i[create update]
  before_validation :normalize_newlines,       on: %i[create update]

  validates :short_path, uniqueness: true, unless: :short_path_blank?
  # validates :tweet, length:   { maximum: 250 }
  validates :summary, length: { maximum: 200 }

  before_save :update_or_create_redirect
  after_destroy :update_locale_articles_count
  after_save :update_locale_articles_count

  default_scope { order(published_at: :desc) }

  scope :last_2_weeks, -> { where('published_at BETWEEN ? AND ?', Time.now.utc - 2.weeks, Time.now.utc) }

  def previous
    canonical_previous
  end

  def next
    # TODO: mirror the canonical_previous logic
    Article.next(self).where(locale: I18n.locale).first
  end

  def path
    if published?
      published_at.strftime("/%Y/%m/%d/#{slug}")
    else
      "/drafts/articles/#{draft_code}"
    end
  end

  # Overwrites slug_exists? from Slug. We allow duplicate slugs on different published_at dates.
  def slug_exists?
    Article.on(published_at).exists?(slug: slug)
  end

  def collection_root?
    collection_posts.any?
  end

  def in_collection?
    # TODO: this is a hack
    collection_id.present?
  end

  delegate :blank?, to: :short_path, prefix: true

  def content_and_notes
    [content, notes].join "\n\n"
  end

  def content_rendered include_media: true
    Kramdown::Document.new(
      MarkdownMedia.parse(content_and_notes, include_media: include_media),
      input:                     content_format.to_sym,
      remove_block_html_tags:    false,
      transliterated_header_ids: true,
      header_links:              true,
      html_to_native:            true
    ).to_html.html_safe
  end

  def related
    @related ||= find_related_articles
  end

  def aggregate_translation_page_views
    [page_views, localizations.map(&:page_views)].flatten.sum
  end

  # TEMP: TODO: move to database column and form field
  def lede
    content.strip.split("\n").first
  end

  private

  def canonical_previous
    article_select = <<-SQL
            a1.id,
            a1.canonical_id,
            a1.locale,
            a1.published_at as ts1 ,
            a2.id,
            CASE
              WHEN a1.canonical_id IS NULL THEN a1.published_at
              ELSE a2.published_at
            END as canonical_published_at
    SQL
    article_self_join = <<-SQL
   JOIN articles a2 ON COALESCE(a1.canonical_id, a1.id) = a2.id
    SQL

    query = Article
              .select(article_select)
              .from("articles a1")
              .joins(article_self_join)
              .where('a1.id < COALESCE(?,?)', self.canonical_id, self.id)
              .where('a1.published_at <= ?', self.published_at)
              .where('a1.locale': [I18n.default_locale, I18n.locale].uniq)
              .where('a1.publication_status = ?', 'published')
              .reorder('canonical_published_at' => :desc)
              .limit(1)

    Article.find(query.first&.id)&.preferred_localization

  rescue ActiveRecord::RecordNotFound
    nil
  end

  def find_related_articles
    return {} if categories.blank?

    # we do not want the current article to show up in related articles
    articles_to_exclude = [id]
    categories.each_with_object({}) do |category, hash|
      # get 3 articles that we haven't seen yet in a previous iteration of this loop
      related_articles = category.articles.english.live.published.limit(3).where.not(id: articles_to_exclude)

      # save the IDs of these articles so we can exclude them in the next iteration of this loop
      articles_to_exclude += related_articles.pluck(:id)

      hash[category] = related_articles
    end
  end

  def absolute_short_path
    "/#{short_path}"
  end

  def generate_published_dates
    return if published_at.blank?

    self.year  = published_at.year                     if published_at.year.present?
    self.month = published_at.month.to_s.rjust(2, '0') if published_at.month.present?
    self.day   = published_at.day.to_s.rjust(2, '0')   if published_at.day.present?
  end

  def normalize_newlines
    tweet.presence&.gsub!("\r\n", "\n")
    summary.presence&.gsub!("\r\n", "\n")
  end

  def update_or_create_redirect
    return if short_path.blank?

    # TODO: name this conditional's concept, extract to a private method
    if redirect.present? &&
       (short_path_changed? || slug_changed? || published_at_changed? || publication_status_changed?)
      redirect.update(source_path: absolute_short_path, target_path: path)
    elsif Redirect.exists?(source_path: absolute_short_path)
      errors.add(:short_path, ' is a path that already points to a redirect')
    elsif publication_status == 'published'
      Redirect.create(source_path: absolute_short_path, target_path: path, article_id: id)
    end
  end

  def update_locale_articles_count
    original_locale = saved_change_to_locale.first if saved_change_to_locale?
    return if locale.blank? && original_locale.blank?

    article_locales = Locale.where(abbreviation: [locale, original_locale].compact)

    return if article_locales.blank?

    article_locales.each do |article_locale|
      articles_count = Article.live.published.where(locale: article_locale.abbreviation).count
      article_locale.update(articles_count: articles_count)
    end
  end
end
