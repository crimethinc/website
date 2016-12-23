class Podcast < ApplicationRecord
  has_many :episodes

  def path
    "/podcast"
  end
end
