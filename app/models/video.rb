class Video < ApplicationRecord
  default_scope { order("published_at DESC") }

  def path
    "/videos/#{slug}"
  end
end
