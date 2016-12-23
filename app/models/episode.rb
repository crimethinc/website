class Episode < ApplicationRecord
  belongs_to :podcast

  def path
    "/podcast/#{to_param}"
  end
end
