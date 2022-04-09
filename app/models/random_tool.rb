class RandomTool
  TOOL_CLASSES = %w[Book Logo Poster Sticker Video Zine].freeze

  class << self
    delegate :sample, to: :new
  end

  def sample
    random_tool_class.constantize.readonly.find random_tool_id
  end

  private

  def random_tool_class
    @random_tool_class ||= TOOL_CLASSES.sample
  end

  def random_tool_id
    random_tool_class.constantize.readonly.live.published.pluck(:id).sample
  end
end
