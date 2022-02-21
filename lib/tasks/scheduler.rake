desc 'This task is called by the Heroku scheduler add-on'
task destroy_expired_support_sessions: :environment do
  puts '==> Destroying expired SupportSessions…'
  SupportSession.where('expires_at < ?', Time.current).destroy_all
  puts '==> All done!'
end

desc 'Tweet to @CrimethIncHour account'
namespace :tweet do
  desc 'Find and tweet a random tool'
  task random_tool: :environment do
    tool = RandomTool.sample

    tweet_text = <<~TWEET_TEXT
      #{tool.class.name}: #{tool.name}

      https://cwc.im#{tool.path}
    TWEET_TEXT

    image_url = if tool.image.is_a? ActiveStorage::Attached::One
                  puts tool.image.url
                else
                  puts tool.image
                end

    tempfile = Down.download image_url

    twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV.fetch('SYNDICATION_TWITTER_KEY')           { 'TODO' }
      config.consumer_secret     = ENV.fetch('SYNDICATION_TWITTER_SECRET')        { 'TODO' }
      config.access_token        = ENV.fetch('SYNDICATION_TWITTER_ACCESS_TOKEN')  { 'TODO' }
      config.access_token_secret = ENV.fetch('SYNDICATION_TWITTER_ACCESS_SECRET') { 'TODO' }
    end

    twitter_client.update_with_media(tweet_text, tempfile)
  end
end
