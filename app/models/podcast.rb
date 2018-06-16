class Podcast < ApplicationRecord
  include Name
  include Searchable

  has_many :episodes

  def path
    '/podcast'
  end

  def meta_description
    unless subtitle.blank? && content.blank?
      subtitle || content.truncate(200)
    end
  end
end
