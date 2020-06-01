class TagAssigner
  def self.parse_glob glob
    return if glob.blank?

    names = glob.split(',').reject(&:blank?).map { |n| n.strip.downcase }.uniq
    tags = names.map do |name|
      # postgres treats everything as case-sensitive by default, so we
      # cannot use find_or_initialize_by until we clean up the tags
      # table and only have lowercase tag.names
      existing_tag = Tag.where('lower(name) = ?', name).first
      existing_tag || Tag.new(name: name)
    end
    new(*tags)
  end

  def initialize *tags
    @tags = tags
  end

  attr_accessor :tags

  def assign_tags_to! taggable
    @tags.each do |tag|
      tag.assign_to!(taggable) unless tag.assigned_to?(taggable)
    end
  end
end
