desc "Rollup job for page views table"
task page_views_rollup: :environment do
  View.all.each do |view|
    if Rails.env.development?
      puts "Article ID: #{view.article.id}"
      puts "Page Views before update: #{view.article.page_views}"
    end

    view.article.page_views += 1
    view.article.save!

    if Rails.env.development?
      puts "Page Views after update:  #{view.article.page_views}"
    end

    view.destroy
    puts
  end
end