class Tagging < ApplicationRecord
  TAGGABLES = [
    ARTICLE   = 'Article'.freeze,
    PAGE      = 'Page'.freeze,
    POSTER    = 'Poster'.freeze,
    STICKER   = 'Sticker'.freeze,
    ZINE      = 'Zine'.freeze,
    BOOK      = 'Book'.freeze
  ].freeze

  belongs_to :tag
  belongs_to :taggable, polymorphic: true, touch: true

  validates :tag, :taggable, presence: true
  validates :taggable_type, inclusion: { in: TAGGABLES }
end
