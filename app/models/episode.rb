class Episode < ApplicationRecord
  include Name

  belongs_to :podcast

  default_scope { order(id: :desc) }

  after_create :generate_slug

  scope :live, -> { where('published_at < ?', Time.now) }

  def path
    "/podcast/#{to_param}"
  end

  def to_param
    slug
  end

  def episode_id_in_podcast
    index_in_podcast = podcast.episodes.reverse.find_index(self)
    if index_in_podcast.blank?
      1
    else
      index_in_podcast + 1
    end
  end

  def generate_slug
    update slug: [podcast.episode_prefix, episode_id_in_podcast].reject(&:blank?).join('-')
  end

  def meta_description
    subtitle || content.truncate(200) unless subtitle.blank? && content.blank?
  end

  def meta_image
    image.presence || t('head.meta_image_url')
  end

  def duration_string
    duration_in_seconds = duration.to_i.minutes

    hours   =  (duration_in_seconds / 3600).to_i
    minutes =  (duration_in_seconds / 60 - hours * 60).to_i
    seconds =  (duration_in_seconds - (minutes * 60 + hours * 3600)).to_i

    [format('%.2d', hours), format('%.2d', minutes), format('%.2d', seconds)].join(':')
  end
end
