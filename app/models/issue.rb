class Issue < ApplicationRecord
  include MultiPageTool

  belongs_to :journal

  def namespace
    'journals'
  end

  def path
    "/journals/#{journal.slug}/#{issue}"
  end
end
