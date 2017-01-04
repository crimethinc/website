class Book < ApplicationRecord
  def path
    "/books/#{slug}"
  end

  def name
    if title.present? && subtitle.present?
      "#{title} : #{subtitle}"
    else
      title
    end
  end
end
