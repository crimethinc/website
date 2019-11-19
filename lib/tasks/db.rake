require 'fileutils'

namespace :db do
  namespace :dump do
    desc 'Import pg dump into local development DB'
    task import: :environment do
      puts '==> Dropping local development DB…'
      sh 'DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rails db:drop'
      puts

      puts '==> Creating local test DB…'
      sh 'rails db:create'
      puts

      puts '==> Populate DB from pg dump file…'
      sh 'psql crimethinc_development < database-dumps/crimethinc_production_db_dump.sql'
    end

    desc 'Pull production DB'
    task export: %i[pull scrub dump upload]

    desc 'Pull production DB'
    task pull: :environment do
      puts '==> This requires that you have Heroku access to this production app'
      puts

      puts '==> Dropping local development DB…'
      sh 'DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rails db:drop'
      puts

      puts '==> Pulling remote production DB…'
      sh 'heroku pg:pull DATABASE_URL crimethinc_development --app crimethinc'
      puts

      puts '==> Creating local test DB…'
      sh 'rails db:create'
    end

    desc 'Scrub private production data from DB'
    task scrub: :environment do
      puts '==> Scrubbing DB…'
      puts '==> Scrubbing Users…'

      # delete all users except User ID #1, to reuse that ID
      User.all.each do |user|
        user.id == 1 ? next : user.destroy
      end

      # update the first user instead of creating a new one,
      # so to not reveal how many production users there are
      password = '1234567890' * 3
      publisher_role = User::ROLES.index :publisher

      User.find(1).update username:              :publisher,
                          password:              password,
                          password_confirmation: password,
                          role:                  publisher_role
      puts

      puts '==> Scrubbing drafts…'
      # TODO: add #publication_status to these models: Definition Episode Podcast
      [Article, Book, Issue, Journal, Logo, Page, Poster, Sticker, Video, Zine].each do |klass|
        klass.draft.destroy_all
      end
    end

    desc 'Dump local development DB'
    task dump: :environment do
      # ensure that the db dumps directory exists
      FileUtils.mkdir_p Rails.root.join 'database-dumps'

      puts '==> Dumping local development DB…'
      # create a PG dump and save it to the db dumps directory
      sh 'pg_dump --dbname=crimethinc_development --file=database-dumps/crimethinc_production_db_dump.sql'
    end

    desc 'Upload DB dump to S3'
    task upload: :environment do
      puts '==> Uploading local development DB dump to S3…'

      # check for required env vars
      env_vars = [
        aws_access_key_id     = ENV.fetch('AWS_ACCESS_KEY_ID')     { 'TODO' },
        aws_secret_access_key = ENV.fetch('AWS_SECRET_ACCESS_KEY') { 'TODO' },
        s_3_bucket = ENV.fetch('S3_BUCKET') { 'TODO' }
      ]

      # exit if any env vars aren't set
      if env_vars.include? 'TODO'
        puts 'You need to set these as environment variables or in a .env file:'
        puts 'AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, S3_BUCKET'
        exit
      end

      # config AWS
      Aws.config.update(
        region:      'us-east-1',
        credentials: Aws::Credentials.new(aws_access_key_id, aws_secret_access_key)
      )

      # client is for making file public. s_3 is for file upload.
      client = Aws::S3::Client.new
      s_3    = Aws::S3::Resource.new

      # reference an existing bucket by name
      bucket_name = s_3_bucket
      bucket      = s_3.bucket(bucket_name)
      bucket_url  = bucket.url

      # Get just the file name
      file_name = 'database-dumps/crimethinc_production_db_dump.sql'

      # Create the object to upload
      obj = s_3.bucket(bucket_name).object(file_name)

      # Upload it
      obj.upload_file file_name

      # Setting the object to public-read
      client.put_object_acl(
        acl:    'public-read',
        bucket: bucket_name,
        key:    file_name
      )

      download_url = [bucket_url, file_name].join('/')
      puts "SUCCESS! File written to S3: #{download_url}"
    end

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
  end
end
