FactoryBot.define do
  factory :zine, parent: :tool, class: 'Zine' do
    locale { 'en' }

    after(:build) do |tool|
      locale = Locale.find_by(abbreviation: tool.locale)
      if locale.blank?
        trait_sym = tool.locale.underscore.to_sym
        create(:locale, trait_sym)
      end
    end
  end
end
