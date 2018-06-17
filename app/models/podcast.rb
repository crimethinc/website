class Podcast < ApplicationRecord
  include Name
  include Searchable

  has_many :episodes

  def path
    '/podcast'
  end

  def meta_description
    subtitle || content.truncate(200) unless subtitle.blank? && content.blank?
  end
end
