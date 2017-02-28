FactoryGirl.define do
  factory :user do
    sequence :email { |n| "user#{n}@example.com" }
    sequence :username { |n| "user#{n}" }
    sequence :display_name { |n| "User #{n}" }
    password "x" * 30
  end
end
