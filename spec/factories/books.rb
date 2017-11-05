FactoryBot.define do
  factory :book do
    title "MyBook"
    zine false
    status_id 1
  end

  trait :zine do
    zine true
  end
end