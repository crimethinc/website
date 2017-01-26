class TagAssigner
  def self.parse_glob(glob)
    new(*glob.split(","))
  end

  def initialize(*names)
    @tags = names.map { |name| Tag.find_or_initialize_by(name: name.strip) }
  end

  attr_accessor :tags

  def assign_tags_to!(taggable)
    @tags.each do |tag|
      Tagging.create!(tag: tag, taggable: taggable)
    end
  end
end
