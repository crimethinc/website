desc "Rollup job for page views table"
task :page_views_rollup => :environment do
  View.all.each do |view|
    puts "ID: #{view.article.id}"
    puts view.article.page_views
    view.article.page_views += 1
    view.article.save!
    puts view.article.page_views
    view.destroy
    puts
  end
end