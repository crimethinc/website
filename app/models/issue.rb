class Issue < ApplicationRecord
  include MultiPageTool

  belongs_to :journal
end
