FactoryBot.define do
  factory :zine, parent: :tool, class: 'Zine' do
    locale { 'en' }
  end
end
