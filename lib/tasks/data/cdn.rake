namespace :data do
  namespace :cdn do
    # Helper method to DRY these tasks
    def migrate_table klass:, attrs:
      klass.find_each do |obj|
        puts "==> Checking if CDN migration needed #{klass}: #{obj.id}"
        update_obj = false

        attrs.each do |attr|
          update_obj = true if obj.send(attr) =~ /cloudfront/i # rubocop:disable Performance/RegexpMatch

          if update_obj == true && obj.send(attr).present?
            puts "==> Migrating CDN: #{klass}: #{obj.id}"
            obj.update attr => obj.send(attr).gsub('cloudfront.', 'cdn.')
          end
        end
      end
    end

    desc 'Migrate everything to new CDN'
    task migrate: %i[
      migrate:articles
      migrate:books
      migrate:zines
      migrate:journals
      migrate:issues
      migrate:podcasts
      migrate:episodes
      migrate:posters
      migrate:stickers
      migrate:redirects
    ]

    namespace :migrate do
      desc 'Migrate articles to new CDN'
      task articles: :environment do
        migrate_table klass: Article, attrs: %i[content image image_description image_mobile summary summary]
      end

      desc 'Migrate books to new CDN'
      task books: :environment do
        migrate_table klass: Book, attrs: %i[content description summary]
      end

      desc 'Migrate zines to new CDN'
      task zines: :environment do
        migrate_table klass: Zine, attrs: %i[content description summary]
      end

      desc 'Migrate journals to new CDN'
      task journals: :environment do
        migrate_table klass: Journal, attrs: %i[content description summary]
      end

      desc 'Migrate issues to new CDN'
      task issues: :environment do
        migrate_table klass: Issue, attrs: %i[content description summary]
      end

      desc 'Migrate podcasts to new CDN'
      task podcasts: :environment do
        migrate_table klass: Podcast, attrs: %i[image content copyright]
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
