class Episode < ApplicationRecord
  belongs_to :podcast

  def name
    if title.present? && subtitle.present?
      "#{title} : #{subtitle}"
    else
      title
    end
  end

  def path
    "/podcast/#{to_param}"
  end

  def meta_description
    subtitle || content.truncate(200)
  end
end
