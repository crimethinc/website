FactoryBot.define do
  factory :book do
    title { 'MyBook' }
    publication_status { :published }
  end
end
