FactoryBot.define do
  factory :podcast do
    sequence(:title) { |n| "anarchy #{n}" }
  end
end
