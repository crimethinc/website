FactoryBot.define do
  factory :zine do
    title { 'MyZine' }
    locale { 'en' }

    after(:build) do |tool|
      locale = Locale.find_by(abbreviation: tool.locale)
      if locale.blank?
        trait_sym = tool.locale.underscore.to_sym
        create(:locale, trait_sym)
      end
    end
  end

  trait(:live) do
    published_at { 1.day.ago }
    publication_status { 'published' }
  end
end
