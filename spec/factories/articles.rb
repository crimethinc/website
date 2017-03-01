FactoryGirl.define do
  factory :article do
    published_at { Time.now }
    sequence :title { |n| "Article #{n}" }
    short_path SecureRandom.hex
  end
end
