FactoryBot.define do
  factory :article do
    published_at { Time.now.utc }
    publication_status { 'published' }
    sequence(:title) { |n| "Article #{n}" }
    sequence(:content) { |n| "content for article #{n}" }
    short_path { SecureRandom.hex }
    locale { 'en' }

    after(:build) do |article|
      locale = Locale.find_by(abbreviation: article.locale)
      if locale.blank?
        trait_sym = article.locale.underscore.to_sym
        create(:locale, trait_sym)
      end
    end
  end

  trait(:spanish) { locale { 'es' } }
  trait(:danish)  { locale { 'da' } }
  trait(:german)  { locale { 'de' } }
  trait(:finnish) { locale { 'fi' } }
  trait(:french)  { locale { 'fr' } }
  trait(:greek)   { locale { 'gr' } }
  trait(:hebrew)  { locale { 'he' } }
  trait(:italian) { locale { 'it' } }
  trait(:swedish) { locale { 'sv' } }
  trait(:turkish) { locale { 'tr' } }
  trait(:portuguese)    { locale { 'pt' } }
  trait(:portuguese_br) { locale { 'pt-br' } }
end
