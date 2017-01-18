class Video < ApplicationRecord
  def name
    if title.present? && subtitle.present?
      "#{title} : #{subtitle}"
    else
      title
    end
  end
end
