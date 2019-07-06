class Journal < ApplicationRecord
  include MultiPageTool

  has_many :issues, dependent: :destroy

  def path
    "/journals/#{slug}"
  end

  def meta_description
    subtitle || description
  end
end
