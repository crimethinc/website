class Status < ApplicationRecord
  has_many :articles
  has_many :books
  has_many :logos
  has_many :posters
  has_many :videos

  class << self
    def options_for_select
      Status.all.map { |s| [s.name.capitalize, s.id] }
    end
  end
end
