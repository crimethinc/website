FactoryBot.define do
  factory :episode do
    podcast
    title { 'Test Episode' }
    publication_status { 'published' }
    published_at { 1.day.ago }
  end
end
