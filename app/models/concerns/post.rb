module Post
  extend ActiveSupport::Concern

  include Name
  include Searchable
  include Slug

  included do
    belongs_to :user, optional: true
    belongs_to :status

    scope :draft,       -> { where(status: Status.find_by(name: "draft")) }
    scope :edited,      -> { where(status: Status.find_by(name: "edited")) }
    scope :designed,    -> { where(status: Status.find_by(name: "designed")) }
    scope :published,   -> { where(status: Status.find_by(name: "published")) }

    before_validation :generate_draft_code, on: [:create, :update]
  end

  # article states through the process from creation to publishing
  def draft?
    status.name == "draft"
  end

  def edited?
    status.name == "edited"
  end

  def designed?
    status.name == "designed"
  end

  def published?
    status.name == "published"
  end

  def dated?
    published_at.present?
  end

  def meta_description
    if summary.blank?
      html = Kramdown::Document.new(
        content,
        input: :kramdown,
        remove_block_html_tags: false,
        transliterated_header_ids: true
      ).to_html.to_s

      doc = Nokogiri::HTML(html)
      doc.css("body").text.truncate(200)
    else
      summary
    end
  end

  private

  def generate_draft_code
    self.draft_code ||= SecureRandom.hex
  end
end
