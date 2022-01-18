class RandomTool
  TOOL_CLASSES = %w[Book Logo Poster Sticker Video Zine].freeze

  class << self
    delegate :sample, to: :new
  end

  def initialize; end

  def sample
    random_tool = all.shift

    klass = random_tool.first
    id    = random_tool.last

    klass.constantize.readonly.find id
  end

  private

  def all
    TOOL_CLASSES.shuffle.map do |klass|
      id = klass.constantize.readonly.live.published.pluck(:id).sample
      [klass, id]
    end
  end
end
