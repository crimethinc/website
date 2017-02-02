class Book < ApplicationRecord
  include Name
  include Slug

  def path
    "/books/#{slug}"
  end

  def image
    "https://cloudfront.crimethinc.com/assets/books/#{slug}/photo.jpg"
  end

  def image_description
    "Photo of '#{title}' book cover"
  end
end
