namespace :cdn do
  namespace :migrate do
    desc 'Migrate articles to new CDN'
    task articles: :environment do
    end

    desc 'Migrate books to new CDN'
    task books: :environment do
    end

    desc 'Migrate zines to new CDN'
    task zines: :environment do
    end

    desc 'Migrate journals to new CDN'
    task journals: :environment do
    end

    desc 'Migrate issues to new CDN'
    task issues: :environment do
    end

    desc 'Migrate podcasts to new CDN'
    task podcasts: :environment do
    end

    desc 'Migrate episodes to new CDN'
    task episodes: :environment do
    end

    desc 'Migrate posters to new CDN'
    task posters: :environment do
    end

    desc 'Migrate stickers to new CDN'
    task stickers: :environment do
    end

    desc 'Migrate redirects to new CDN'
    task redirects: :environment do
      Redirect.find_each do |redirect|
        puts "==> Checking if CDN migration needed Redirect #{redirect.id}"
        if redirect.source_path =~ /cloudfront/i || redirect.target_path =~ /cloudfront/i
          puts "==> Migrating CDN: Redirect: #{redirect.id}"
          redirect.update source_path: redirect.source_path.gsub('cloudfront.', 'cdn.'), target_path: redirect.target_path.gsub('cloudfront.', 'cdn.')
        end
      end
    end

  end
end
