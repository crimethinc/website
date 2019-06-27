class Tag < ApplicationRecord
  include Slug

  has_many :taggings, dependent: :destroy
  has_many :articles, through: :taggings, source: :taggable, source_type: Tagging::ARTICLE
  has_many :pages, through: :taggings, source: :taggable, source_type: Tagging::PAGE
  has_many :posters, through: :taggings, source: :taggable, source_type: Tagging::POSTER
  has_many :stickers, through: :taggings, source: :taggable, source_type: Tagging::STICKER
  has_many :zines, through: :taggings, source: :taggable, source_type: Tagging::ZINE
  has_many :books, through: :taggings, source: :taggable, source_type: Tagging::BOOK

  before_validation :strip_whitespace, on: %i[create update]

  validates :name, uniqueness: true

  def strip_whitespace
    self.name = name.strip
  end

  def assigned_to?(taggable)
    in? taggable.tags
  end

  def assign_to!(taggable)
    save! if new_record?
    taggings.create!(taggable: taggable)
  end
end
