class Article < ApplicationRecord
  def path
    published_at.strftime("/%Y/%m/%d/#{slug}")
  end
end
