class Episode < ApplicationRecord
  belongs_to :podcast

  def path
    "/podcast/#{to_param}"
  end

  def meta_description
    subtitle || content.truncate(200)
  end
end
