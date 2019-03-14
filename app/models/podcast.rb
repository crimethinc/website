class Podcast < ApplicationRecord
  include Name
  include Searchable

  has_many :episodes, dependent: :destroy

  def path
    '/podcast'
  end

  def meta_description
    subtitle || content.truncate(200) unless subtitle.blank? && content.blank?
  end

  def latest_episode
    episodes.first
  end
end
