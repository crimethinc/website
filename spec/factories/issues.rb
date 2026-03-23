FactoryBot.define do
  factory :issue do
    journal
    title { 'Issue 1' }
    slug { 'issue-1' }
    issue { '1' }
    publication_status { 'published' }
    published_at { 1.day.ago }
  end
end
