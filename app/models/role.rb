class Role < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
