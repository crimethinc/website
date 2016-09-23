class Link < ApplicationRecord
  belongs_to :user, optional: true

  validates :name, presence: :true
  validates :url,  presence: :true
end
