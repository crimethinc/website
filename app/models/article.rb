class Article < ApplicationRecord
  include Post

  has_many :taggings, dependent: :destroy, as: :taggable
  has_many :tags, through: :taggings
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations
  has_many :collection_posts, foreign_key: :collection_id, class_name: :Article, dependent: :destroy, inverse_of: :collection

  has_one    :redirect, dependent: :destroy
  belongs_to :collection, foreign_key: :collection_id, class_name: :Article, touch: true, inverse_of: :collection_posts

  before_validation :generate_published_dates, on: [:create, :update]
  before_validation :normalize_newlines,       on: [:create, :update]

  validates :short_path, uniqueness: true, unless: :short_path_blank?
  # validates :tweet, length:   { maximum: 250 }
  validates :summary, length: { maximum: 200 }

  before_save :update_or_create_redirect

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
    Article.on(published_at).where(slug: slug).exists?
  end

  def collection_root?
    collection_posts.any?
  end

  def in_collection?
    # TODO: this is a hack
    collection_id.present?
  end

  delegate :blank?, to: :short_path, prefix: true

  def content_rendered include_media: true
    Kramdown::Document.new(
      MarkdownMedia.parse(content, include_media: include_media),
      input: content_format.to_sym,
      remove_block_html_tags: false,
      transliterated_header_ids: true,
      html_to_native: true
    ).to_html.html_safe
  end

  def related
    related_articles = {}

    if categories.present?
      categories.each do |category|
        articles = []
        category.articles.published[0..7].each do |article|
          next unless article != self &&
                      articles.length < 3 &&
                      !related_articles.values.flatten.include?(article)

          articles << article
        end

        related_articles[category] = articles
      end
    end

    related_articles
  end

  private

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

    if redirect.present? && (short_path_changed? || slug_changed? || published_at_changed? || publication_status_changed?)
      redirect.update(source_path: '/' + short_path, target_path: path)
    elsif Redirect.where(source_path: '/' + short_path).exists?
      errors.add(:short_path, ' is a path that already points to a redirect')
    elsif publication_status == 'published'
      Redirect.create(source_path: '/' + short_path, target_path: path, article_id: id)
    end
  end
end
