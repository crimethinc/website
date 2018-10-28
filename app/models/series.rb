class Series < ApplicationRecord
  has_many :journals, dependent: :destroy
end
