class Book < ApplicationRecord
  include MultiPageTool

  # Overrides
  def ask_for_donation?
    downloads_available?
  end
end
