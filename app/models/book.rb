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

  def image
    "http://thecloud.crimethinc.com/assets/books/#{slug}/photo.jpg"
  end

  def image_description
    "Photo of '#{title}' book"
  end
end
