class Book < ApplicationRecord
  include NameFromTitle

  def path
    "/books/#{slug}"
  end

  def image
    extension = slug == "contradictionary" ? "png" : "jpg"
    "https://cloudfront.crimethinc.com/assets/books/#{slug}/photo.#{extension}"
  end

  def image_description
    "Photo of '#{title}' book"
  end
end
