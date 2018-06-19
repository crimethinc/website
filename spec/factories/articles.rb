FactoryBot.define do
  factory :article do
    published_at { Time.now.utc }
    sequence(:title) { |n| "Article #{n}" }
    short_path { SecureRandom.hex }
    association :status
  end
end
