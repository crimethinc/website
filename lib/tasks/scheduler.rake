desc 'This task is called by the Heroku scheduler add-on'
task rollup_page_views: :environment do
  puts 'Rolling up page views…'
  views = View.all

  views.group(:article_id).count.sort.each do |article_id, page_view_count|
    # Find the corresponding Article
    article = Article.find(article_id)

    # Update the page view count for this Article
    # update_columns to avoid hitting callbacks, namely updating Search index
    article.update_columns(page_views: article.page_views + page_view_count)
  end

  views.destroy_all
  puts '…done.'
end

desc 'This task is called by the Heroku scheduler add-on'
task destroy_expired_subscription_sessions: :environment do
  puts 'Collecting expired SubscriptionSessions…'
  subscription_sessions = SubscriptionSession.where('expires_at < ?', Time.now)

  if subscription_sessions.present?
    puts '…destroying expired SubscriptionSessions…'
    subscription_sessions.destroy_all
    puts '…all done!'
  else
    puts "there aren't any expired SubscriptionSessions."
    puts "Nothing was deleted."
  end
end
