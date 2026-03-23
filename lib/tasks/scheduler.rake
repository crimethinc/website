desc 'Tweet to @CrimethIncHour account'
namespace :tweet do
  desc 'Find and tweet a random tool'
  task random_tool: :environment do
    Tweet.for(RandomTool.sample).publish
  end
end
