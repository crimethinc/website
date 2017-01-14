class Episode < ApplicationRecord
  belongs_to :podcast

  default_scope { order("id DESC") }

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

  def duration_string
    duration_in_seconds = duration.to_i.minutes

    hours   =  (duration_in_seconds / 3600).to_i
    minutes =  (duration_in_seconds / 60 - hours * 60).to_i
    seconds =  (duration_in_seconds - (minutes * 60 + hours * 3600)).to_i

    ['%.2d' % hours, '%.2d' % minutes, '%.2d' % seconds].join(":")
  end
end
