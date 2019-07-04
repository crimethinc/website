class Series < ApplicationRecord
  has_many :journals, dependent: :destroy
  has_many :issues, dependent: :destroy
end
