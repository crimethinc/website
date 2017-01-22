class Theme < ApplicationRecord
  has_many :articles
  before_validation :strip_whitespace, on: [:create, :update]

  private

  def strip_whitespace
    self.name = name.strip
  end
end
