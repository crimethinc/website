namespace :db do
  desc "Dump production db, scrub private stuff, upload to S3. Used by 'rake db:seed'"
  task export: :environment do
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
    puts

    puts '==> Scrubbing DB…'
    puts '==> Scrubbing Users…'
    User.destroy_all

    password = '1234567890' * 3
    publisher_role = User::ROLES.index :publisher

    User.create! username:              :publisher,
                 password:              password,
                 password_confirmation: password,
                 role:                  publisher_role
    puts

    puts '==> Scrubbing drafts…'
    # TODO: add #publication_status to these models: Definition Episode Podcast
    [Article, Book, Issue, Journal, Logo, Page, Poster, Sticker, Video, Zine].each do |klass|
      klass.draft.destroy_all
    end
    puts

    puts '==> All done!'
  end
end
