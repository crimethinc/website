namespace :db do
  desc 'Export (scrubbed) production DB to S3'
  task export: %i[db:export:pull db:export:scrub db:export:dump db:export:upload]

  namespace :export do
    desc 'Pull production DB'
    task pull: :environment do
      puts '==> This requires that you have Heroku access to this production app'
      puts

      puts '==> Dropping local development DB…'
      sh 'DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rake db:drop'
      puts

      puts '==> Pulling remote production DB…'
      sh 'heroku pg:pull DATABASE_URL crimethinc_development --app the-crimethinc-production'
      puts

      puts '==> Creating local test DB…'
      sh 'rake db:create'
    end

    desc 'Scrub private production data from DB'
    task scrub: :environment do
      puts '==> Scrubbing DB…'
      puts '==> Scrubbing Users…'

      # Delete all users except User ID #1, to reuse that ID
      User.find_each do |user|
        user.id == 1 ? next : user.destroy
      end

      # Update the first user instead of creating a new one,
      #   so to not reveal how many production users there are
      password = '1234567890' * 3
      publisher_role = User::ROLES.index :publisher

      User.find(1).update username:              :publisher,
                          password:              password,
                          password_confirmation: password,
                          role:                  publisher_role

      puts '==> Scrubbing drafts…'
      # TODO: add #publication_status to these models: Definition Episode Podcast
      [Article, Book, Issue, Journal, Logo, Page, Poster, Sticker, Video, Zine].each do |klass|
        klass.draft.destroy_all
      end

      # rubocop:disable Rails/SkipsModelValidations
      puts '==> Scrubbing article page view counts…'
      Article.update_all(page_views: 0)
      # rubocop:enable Rails/SkipsModelValidations
    end

    desc 'Dump local development DB'
    task dump: :environment do
      # Ensure that the db dumps directory exists
      FileUtils.mkdir_p Rails.root.join 'database-dumps'

      puts '==> Dumping local development DB…'
      # Create a PG dump and save it to the db dumps directory
      sh 'pg_dump --dbname=crimethinc_development --file=database-dumps/crimethinc_production_db_dump.sql'
    end

    desc 'Upload DB dump to S3'
    task upload: :environment do
      puts '==> Uploading local development DB dump to S3…'

      # Check for required env vars
      env_vars = [
        aws_access_key_id     = ENV.fetch('AWS_ACCESS_KEY_ID_FOR_DB_EXPORT')     { 'TODO' },
        aws_secret_access_key = ENV.fetch('AWS_SECRET_ACCESS_KEY_FOR_DB_EXPORT') { 'TODO' },
        aws_bucket            = ENV.fetch('AWS_BUCKET_FOR_DB_EXPORT')            { 'TODO' },
        aws_region            = ENV.fetch('AWS_REGION_FOR_DB_EXPORT')            { 'TODO' }
      ]

      # Exit if any env vars aren't set
      if env_vars.include? 'TODO'
        puts 'You need to set these as environment variables or in a .env file:'
        puts '  AWS_ACCESS_KEY_ID_FOR_DB_EXPORT'
        puts '  AWS_SECRET_ACCESS_KEY_FOR_DB_EXPORT'
        puts '  AWS_BUCKET_FOR_DB_EXPORT'
        puts '  AWS_REGION_FOR_DB_EXPORT'
        exit
      end

      # Configure AWS
      Aws.config.update(
        region:      aws_region,
        credentials: Aws::Credentials.new(aws_access_key_id, aws_secret_access_key)
      )

      # For making file public
      client = Aws::S3::Client.new
      # for file upload
      aws_s_3 = Aws::S3::Resource.new

      # Reference an existing bucket by name
      bucket_name = aws_bucket
      bucket      = aws_s_3.bucket(bucket_name)
      bucket_url  = bucket.url

      # Get just the file name
      file_name = 'database-dumps/crimethinc_production_db_dump.sql'

      # Create the object to upload
      obj = aws_s_3.bucket(bucket_name).object(file_name)

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
  end
end
