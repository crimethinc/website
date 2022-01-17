class RandomTool
  class << self
    delegate :sample, to: :new
  end

  def initialize; end

  def sample
    tool  = all.sample
    klass = tool.keys.first
    id    = tool.values.first

    klass.constantize.readonly.find id
  end

  private

  def all
    [sample_book, sample_logo, sample_poster, sample_sticker, sample_video, sample_zine]
  end

  def sample_book
    klass = Book
    id = Book.readonly.live.published.pluck(:id).sample
    { klass.name => id }
  end

  def sample_logo
    klass = Logo
    id = Logo.readonly.live.published.pluck(:id).sample
    { klass.name => id }
  end

  def sample_poster
    klass = Poster
    id = Poster.readonly.live.published.pluck(:id).sample
    { klass.name => id }
  end

  def sample_sticker
    klass = Sticker
    id = Sticker.readonly.live.published.pluck(:id).sample
    { klass.name => id }
  end

  def sample_video
    klass = Video
    id = Video.readonly.live.published.pluck(:id).sample
    { klass.name => id }
  end

  def sample_zine
    klass = Zine
    id = Zine.readonly.live.published.pluck(:id).sample
    { klass.name => id }
  end
end
