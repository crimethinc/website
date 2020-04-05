class Book < ApplicationRecord
  include MultiPageTool
  include Featureable

  def ask_for_donation?
    downloads_available?
  end
end
