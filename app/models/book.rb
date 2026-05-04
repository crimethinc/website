class Book < ApplicationRecord
  include MultiPageTool

  self.ignored_columns += [:tweet]

  def ask_for_donation?
    downloads_available?
  end
end
