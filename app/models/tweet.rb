class Tweet
  attr_reader :thing

  class << self
    def for thing
      new thing
    end
  end

  def initialize thing
    @thing = thing
  end

  def publish
    twitter_client.update_with_media(content, image_file)
  end

  private

  def content
    <<~TWEET_TEXT
      #{thing.class.name}:
      #{thing.name}

      #{thing_url}
    TWEET_TEXT
  end

  def image_url
    return thing.image.url if thing.image.is_a? ActiveStorage::Attached::One

    thing.image
  end

  def image_file
    Down.download image_url
  end

  def thing_url
    "https://cwc.im#{thing.path}"
  end

  def twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV.fetch('SYNDICATION_TWITTER_KEY')           { 'TODO' }
      config.consumer_secret     = ENV.fetch('SYNDICATION_TWITTER_SECRET')        { 'TODO' }
      config.access_token        = ENV.fetch('SYNDICATION_TWITTER_ACCESS_TOKEN')  { 'TODO' }
      config.access_token_secret = ENV.fetch('SYNDICATION_TWITTER_ACCESS_SECRET') { 'TODO' }
    end
  end
end
