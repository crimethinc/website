desc 'This task is called by the Heroku scheduler add-on'
task destroy_expired_subscription_sessions: :environment do
  puts '==> Destroying expired SubscriptionSessions…'
  SubscriptionSession.where('expires_at < ?', Time.current).destroy_all
  puts '==> All done!'
end
