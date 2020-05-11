class Book < ApplicationRecord
  include MultiPageTool
  include Featureable

  scope :for_index, -> { where.not(hide_from_index: true).reorder(position: :asc).order(title: :asc) }

  def ask_for_donation?
    downloads_available?
  end
end
