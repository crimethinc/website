FactoryGirl.define do
  factory :status do
    initialize_with { Status.find_or_create_by(name: "draft") }
  end

  trait :draft do
    initialize_with { Status.find_or_create_by(name: "draft") }
  end

  trait :published do
    initialize_with { Status.find_or_create_by(name: "published") }
  end
end
