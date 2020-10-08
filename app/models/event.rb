class Event
  class << self
    def add_field name, content
      Honeycomb.add_field name, content
    end
  end
end
