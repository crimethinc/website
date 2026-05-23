FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    password { 'x' * 30 }

    trait :publisher do
      role { 'publisher' }
    end

    trait :author do
      role { 'author' }
    end
  end
end
