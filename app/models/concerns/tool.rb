module Tool
  extend ActiveSupport::Concern
  include Name
  include Slug
  include Publishable
  include MetaDescription

  included do
    has_many :taggings, dependent: :destroy, as: :taggable
    has_many :tags, through: :taggings

    default_scope { order(slug: :asc) }
  end

  ASSET_BASE_URL = 'https://cloudfront.crimethinc.com/assets'.freeze

  def path
    [nil, namespace, slug].join('/')
  end

  def ask_for_donation?
    false
  end

  def namespace
    self.class.to_s.tableize
  end

  def asset_base_url_prefix
    [ASSET_BASE_URL, namespace, slug].join('/')
  end
end
