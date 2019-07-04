class Series < ApplicationRecord
  has_many :issues, dependent: :destroy
end
