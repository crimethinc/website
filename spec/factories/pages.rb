FactoryBot.define do
  factory :page do
    title { 'page title' }
    content { 'page content' }
    publication_status { 'published' }
    published_at { Time.zone.parse '2017-01-01' }
    sequence(:slug) { |n| "slug#{n}" }
    image { 'https://cloudfront.crimethinc.com/assets/pages/start/start-header.jpg' }
  end
end
