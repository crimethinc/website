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
    extension = slug == "contradictionary" ? "png" : "jpg"
    "https://cloudfront.crimethinc.com/assets/books/#{slug}/photo.#{extension}"
  end

  def image_description
    "Photo of '#{title}' book"
  end
end
