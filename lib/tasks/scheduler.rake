desc 'This task is called by the Heroku scheduler add-on'
task destroy_expired_subscription_sessions: :environment do
  puts 'Collecting expired SubscriptionSessions…'
  subscription_sessions = SubscriptionSession.where('expires_at < ?', Time.current)

  if subscription_sessions.present?
    puts '…destroying expired SubscriptionSessions…'
    subscription_sessions.destroy_all
    puts '…all done!'
  else
    puts "there aren't any expired SubscriptionSessions."
    puts 'Nothing was deleted.'
  end
end
