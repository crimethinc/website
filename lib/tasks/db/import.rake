namespace :db do
  desc 'Import (scrubbed) production DB from S3'
  task import: %i[db:import:download db:import:populate]

  namespace :import do
    desc 'Download DB dump from S3'
    task download: :environment do
      # ensure that the db dump directory and file exist
      FileUtils.mkdir_p Rails.root.join 'database-dumps'
      FileUtils.touch Rails.root.join 'database-dumps/crimethinc_production_db_dump.sql'

      # URL to download from
      url = 'https://crimethinc-production.s3.us-west-2.amazonaws.com/database-dumps/crimethinc_production_db_dump.sql'

      puts '==> Downloading remote production DB dump from S3…'
      File.open('database-dumps/crimethinc_production_db_dump.sql', 'wb') do |file|
        # TODO: use Down or HTTP.rb gem instead
        file << URI.open(url).read # rubocop:disable Security/Open
      end
    end

    desc 'Import pg dump into local development DB'
    task populate: :environment do
      unless Rails.env.production?
        puts '==> Dropping local development DB…'
        sh 'DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rake db:drop'
        puts

        puts '==> Creating local test DB…'
        sh 'rake db:create'
        puts
      end

      puts '==> Migrating DB…'
      sh 'rake db:migrate'
      puts

      puts '==> Populate DB from pg dump file…'
      database_port = ENV.fetch('PORT', 5432)
      database_url  = ENV.fetch('DATABASE_URL') { 'crimethinc_development' }

      sh "psql #{database_url} --port=#{database_port} < database-dumps/crimethinc_production_db_dump.sql"
    end
  end
end
