FactoryBot.define do
  factory :podcast do
    sequence(:title) { |n| "anarchy #{n}" }
    sequence(:slug)  { |n| "anarchy-#{n}" }
  end
end
