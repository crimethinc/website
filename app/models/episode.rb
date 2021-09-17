class Episode < ApplicationRecord
  include Name

  belongs_to :podcast

  default_scope { order(id: :desc) }

  after_create :generate_slug
  after_create :generate_episode_number

  scope :live, -> { where('published_at < ?', Time.now.utc) }

  def path
    "/podcasts/#{podcast.slug}/episodes/#{episode_number}"
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

  def generate_episode_number
    update episode_number: episode_id_in_podcast
  end

  def meta_description
    subtitle || content.truncate(200) unless subtitle.blank? && content.blank?
  end

  def meta_image
    image.presence || I18n.t('head.meta_image_url')
  end

  def duration_string
    duration_in_seconds = duration.to_i.minutes

    hours   =  (duration_in_seconds / 3600).to_i
    minutes =  ((duration_in_seconds / 60) - (hours * 60)).to_i
    seconds =  (duration_in_seconds - ((minutes * 60) + (hours * 3600))).to_i

    [
      hours.to_s.rjust(2, '0'),
      minutes.to_s.rjust(2, '0'),
      seconds.to_s.rjust(2, '0')
    ].join(':')
  end
end
