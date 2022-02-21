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
    puts
    puts tweet_text = "#{tool.class.name}: #{tool.name}"
    puts tweet_url  = "https://crimethinc.com#{tool.path}"
    puts tool.image
    puts
  end
end
