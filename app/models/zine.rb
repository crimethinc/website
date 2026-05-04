class Zine < ApplicationRecord
  include MultiPageTool

  self.ignored_columns += [:tweet]
end
