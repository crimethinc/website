class Locale < ApplicationRecord
  before_validation :strip_whitespace, on: [:create, :update]
  before_validation :downcase_abbreviation, on: [:create, :update]

  validates :abbreviation, uniqueness: true
  validates :name_in_english, uniqueness: true
  validates :name, uniqueness: true

  def strip_whitespace
    self.abbreviation    = abbreviation.strip
    self.name_in_english = name_in_english.strip
    self.name            = name.strip
  end

  def downcase_abbreviation
    self.abbreviation = abbreviation.downcase
  end
end
