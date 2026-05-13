FactoryBot.define do
  factory :journal, parent: :tool, class: 'Journal' do
    title { 'Rolling Thunder' }
    slug { 'rolling-thunder' }
  end
end
