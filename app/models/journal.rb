class Journal < ApplicationRecord
  include Name
  include Slug

  has_many :issues, dependent: :destroy

  def path
    "/journals/#{slug}"
  end

  def meta_description
    subtitle || description
  end
end
