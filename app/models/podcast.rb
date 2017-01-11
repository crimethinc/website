class Podcast < ApplicationRecord
  has_many :episodes

  def name
    if title.present? && subtitle.present?
      "#{title} : #{subtitle}"
    else
      title
    end
  end

  def path
    "/podcast"
  end

  def meta_description
    subtitle || content.truncate(200)
  end
end
