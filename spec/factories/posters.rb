FactoryBot.define do
  factory :poster, parent: :tool, class: 'Poster' do
    trait :sticker do
      sticker { true }
    end
  end
end
