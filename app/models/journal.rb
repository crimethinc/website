class Journal < ApplicationRecord
  include MultiPageTool

  belongs_to :series
end
