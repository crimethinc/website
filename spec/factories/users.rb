FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    password 'x' * 30
  end
end
