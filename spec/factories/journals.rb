FactoryBot.define do
  factory :journal do
    title { 'Rolling Thunder' }
    slug { 'rolling-thunder' }
    publication_status { 'published' }
    published_at { 1.day.ago }
  end
end
