namespace :data do
  namespace :cdn do
    # Helper method to DRY these tasks
    def migrate_table klass:, attrs:
      klass.find_each do |obj|
        puts "==> Checking if CDN migration needed #{klass}: #{obj.id}"
        update_obj = false

        attrs.each do |attr|
          if obj.send(attr) =~ /cloudfront/i
            update_obj = true
          end
        end

        attrs.each do |attr|
          if update_obj == true
            puts "==> Migrating CDN: #{klass}: #{obj.id}"
            obj.update attr => obj.send(attr).gsub('cloudfront.', 'cdn.')
          end
        end
      end
    end

    desc 'Migrate everything to new CDN'
    task migrate: %i[migrate:posters migrate:stickers migrate:redirects]

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
        migrate_table klass: Episode, attrs: %i[image content show_notes transcript]
      end

      desc 'Migrate posters to new CDN'
      task posters: :environment do
        migrate_table klass: Poster, attrs: %i[summary description]
      end

      desc 'Migrate stickers to new CDN'
      task stickers: :environment do
        migrate_table klass: Sticker, attrs: %i[summary description]
      end

      desc 'Migrate redirects to new CDN'
      task redirects: :environment do
        migrate_table klass: Redirect, attrs: %i[source_path target_path]
      end

    end
  end
end
