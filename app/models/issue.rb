class Issue < ApplicationRecord
  include MultiPageTool

  belongs_to :series
end
