class Status < ApplicationRecord
  class << self
    def options_for_select
      Status.all.map { |s| [s.name.capitalize, s.id] }
    end
  end
end
