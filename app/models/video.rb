class Video < ApplicationRecord
  include Name

  def path
    "/videos/#{slug}"
  end
end
