FactoryGirl.define do
  factory :article do
    published_at { Time.now }
    sequence :title { |n| "Article #{n}" }
  end
end
