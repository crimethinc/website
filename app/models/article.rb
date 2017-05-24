class Article < ApplicationRecord
  include Post

  belongs_to :theme

  has_many :taggings, dependent: :destroy, as: :taggable
  has_many :tags, through: :taggings
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations
  has_many :contributions, dependent: :destroy
  has_many :collection_posts, foreign_key: :collection_id, class_name: :Article
  has_many :redirects, dependent: :destroy
  belongs_to :collection, foreign_key: :parent_id, class_name: :Article

  accepts_nested_attributes_for :contributions, reject_if: :all_blank, allow_destroy: true

  scope :chronological, -> { order(published_at: :desc) }

  scope :root, -> { where(collection_id: nil) }

  before_validation :generate_slug,            on: [:create, :update]
  before_validation :generate_published_dates, on: [:create, :update]
  before_validation :downcase_content_format,  on: [:create, :update]
  before_validation :normalize_newlines,       on: [:create, :update]

  validates :short_path, uniqueness: true, unless: "short_path.blank?"
  validates :tweet, length: { maximum: 115 }
  validates :summary, length: { maximum: 200 }
  validate :redirect_source_path_unique, on: [:create]
  validate :update_redirect_short_paths, if: :short_path_changed?

  before_save :create_redirect

  default_scope { order("published_at DESC") }
  scope :live,     -> { where("published_at < ?", Time.now) }
  scope :on,       lambda { |date| where("published_at BETWEEN ? AND ?", date.try(:beginning_of_day), date.try(:end_of_day)) }
  scope :recent,   -> { where("published_at BETWEEN ? AND ?", Time.now - 2.days, Time.now) }
  scope :next,     lambda { |article| where("published_at > ?", article.published_at).live.published.order(published_at: :asc).limit(1) }
  scope :previous, lambda { |article| where("published_at < ?", article.published_at).live.published.chronological.limit(1) }

  def path
    if published?
      published_at.strftime("/%Y/%m/%d/#{slug}")
    else
      "/drafts/articles/#{self.draft_code}"
    end
  end

 # Overwrites slug_exists? from Slug.  We allow duplicate slugs on different
 # published_at dates.
  def slug_exists?
    Article.on(published_at).where(slug: slug).exists?
  end

  def collection_root?
    collection_posts.any?
  end

  def in_collection?
    # TODO this is a hack
    collection_id.present?
  end

  private

  def generate_published_dates
    if published_at.present?
      self.year  = published_at.year                     if published_at.year.present?
      self.month = published_at.month.to_s.rjust(2, "0") if published_at.month.present?
      self.day   = published_at.day.to_s.rjust(2, "0")   if published_at.day.present?
    end
  end

  def downcase_content_format
    self.content_format = self.content_format.downcase
  end

  def create_redirect
    unless short_path.blank? || Redirect.exists?(source_path: "/"+short_path, target_path: path)
      Redirect.create(source_path: short_path, target_path: path, article_id: id)
    end
  end

  def redirect_source_path_unique
    unless short_path.blank?
      errors.add(:short_path, ' is already defined by a redirect') if Redirect.where(source_path: "/"+self.short_path).exists?
    end
  end

  def update_redirect_short_paths
    if Redirect.where(source_path: "/"+self.short_path).exists?
      errors.add(:short_path, ' is already defined by a redirect')
    else
      self.redirects.each do |redirect|
        redirect.update_attribute(source_path: self.short_path)
      end
    end
  end

  def normalize_newlines
    tweet.gsub!("\r\n", "\n") if tweet.present?
    summary.gsub!("\r\n", "\n") if summary.present?
  end
end
