class Video < ApplicationRecord
  include NameFromTitle

  default_scope { order("published_at DESC") }

  def path
    "/videos/#{slug}"
  end
end
