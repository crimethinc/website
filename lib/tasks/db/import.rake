namespace :db do
  desc 'Export (scrubbed) production DB to S3'
  task import: %i[db:import:download db:import:populate]

  namespace :import do
    desc 'Download DB dump from S3'
    task download: :environment do
      # ensure that the db dump directory and file exist
      FileUtils.mkdir_p Rails.root.join 'database-dumps'
      FileUtils.touch Rails.root.join 'database-dumps', 'crimethinc_production_db_dump.sql'

      # URL to download from
      url = 'https://s3.amazonaws.com/thecloud.crimethinc.com/database-dumps/crimethinc_production_db_dump.sql'

      puts '==> Downloading remote production DB dump from S3…'
      open('database-dumps/crimethinc_production_db_dump.sql', 'wb') do |file|
        file << open(url).read
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
      database_port = ENV.fetch('PORT')         { 5432 }
      database_url  = ENV.fetch('DATABASE_URL') { crimethinc_development }

      sh "psql #{database_url} --port=#{database_port} < database-dumps/crimethinc_production_db_dump.sql"
    end
  end
end
