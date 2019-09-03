FactoryBot.define do
  factory :podcast do
    created_at { Time.now.utc }
    sequence(:title) { |n| "anarchy #{n}" }
  end
end
