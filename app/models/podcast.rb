class Podcast < ApplicationRecord
  include NameFromTitle

  has_many :episodes

  def path
    "/podcast"
  end

  def meta_description
    subtitle || content.truncate(200)
  end
end
