class Status < ApplicationRecord
  has_many :articles, dependent: :destroy
  has_many :books, dependent: :destroy
  has_many :logos, dependent: :destroy
  has_many :posters, dependent: :destroy
  has_many :videos, dependent: :destroy

  class << self
    def options_for_select
      Status.all.map { |s| [s.name.capitalize, s.id] }
    end
  end
end
