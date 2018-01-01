class Definition < ApplicationRecord
  validates :name,    presence: true, uniqueness: true
  validates :content, presence: true, uniqueness: true
end
