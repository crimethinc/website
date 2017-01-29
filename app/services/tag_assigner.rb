class TagAssigner
  def self.parse_glob(glob)
    names = glob.split(",").reject(&:blank?)
    tags = names.map { |name| Tag.find_or_initialize_by(name: name.strip) }
    new(*tags)
  end

  def initialize(*tags)
    @tags = tags
  end

  attr_accessor :tags

  def assign_tags_to!(taggable)
    @tags.each { |tag| tag.assign_to!(taggable) }
  end
end
