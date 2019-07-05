class Issue < ApplicationRecord
  include MultiPageTool

  belongs_to :journal

  def namespace
    'journals'
  end
end
