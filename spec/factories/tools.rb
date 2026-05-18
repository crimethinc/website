FactoryBot.define do
  factory :tool do
    sequence(:title) { "tool title #{it}" }
    sequence(:subtitle) { "tool title #{it}" }

    transient do
      uploads { [] }
    end

    after(:create) do |tool, context|
      context.uploads.each do |method, attachment|
        tool.public_send(method).attach attachment
      end
    end

    trait :with_built_locale do
      after(:build) do |tool|
        locale = Locale.find_by(abbreviation: tool.locale)
        if locale.blank?
          trait_sym = tool.locale.underscore.to_sym
          create(:locale, trait_sym)
        end
      end
    end

    trait :draft do
      published_at { nil }
      publication_status { 'draft' }
    end

    trait(:not_live) do
      published_at { 1.day.from_now }
      publication_status { 'published' }
    end

    trait :live do
      published_at { 1.day.ago }
      publication_status { 'published' }
    end
  end
end
