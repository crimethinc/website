desc "This task is called by the Heroku scheduler add-on"
task rollup_page_views: :environment do
  puts "Rolling up page views..."
  views = View.all

  views.group(:article_id).count.sort.each do |article_id, page_view_count|
    # Find the corresponding Article
    article = Article.find(article_id)

    # Update the page view count for this Article
    article.update_columns(page_views: article.page_views + page_view_count)
  end

  views.destroy_all
  puts "...done."
end
