class Locale < ApplicationRecord
  before_validation :strip_whitespace, on: %i[create update]
  before_validation :downcase_abbreviation, on: %i[create update]

  validates :abbreviation, uniqueness: true
  validates :name_in_english, uniqueness: true
  validates :name, uniqueness: true

  enum language_direction: %i[ltr rtl]

  default_scope { order(abbreviation: :asc) }

  def display_name
    "#{abbreviation.upcase} : #{name_in_english} / #{name}"
  end

  def strip_whitespace
    self.abbreviation    = abbreviation.strip
    self.name_in_english = name_in_english.strip
    self.name            = name.strip
  end

  def downcase_abbreviation
    self.abbreviation = abbreviation.downcase
  end
end
