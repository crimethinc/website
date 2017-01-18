class Video < ApplicationRecord
  default_scope { order("published_at DESC") }

  def name
    if title.present? && subtitle.present?
      "#{title} : #{subtitle}"
    else
      title
    end
  end
      
  def path
    "/videos/#{slug}"
  end
end
