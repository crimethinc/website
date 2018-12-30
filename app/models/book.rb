class Book < ApplicationRecord
  include MultiPageTool

  def ask_for_donation?
    downloads_available?
  end
end
