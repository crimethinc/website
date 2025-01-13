class Article < ApplicationRecord
  include Post
  include Featureable
  include Translatable

  has_one_attached :header, dependent: :destroy do |attachable|
    attachable.variant :small,  resize_to_limit: [400, 200],   preprocessed: true
    attachable.variant :medium, resize_to_limit: [1000, 500],  preprocessed: true
    attachable.variant :large,  resize_to_limit: [2000, 1000], preprocessed: true
  end

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
    tweet.gsub!("\r\n", "\n")   if tweet.present?
    summary.gsub!("\r\n", "\n") if summary.present?
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
