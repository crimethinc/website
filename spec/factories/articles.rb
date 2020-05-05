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

  trait(:arabic)     { locale { 'ar' } }
  trait(:bengali)    { locale { 'bn' } }
  trait(:czech)      { locale { 'cs' } }
  trait(:chinese)    { locale { 'zh' } }
  trait(:danish)     { locale { 'da' } }
  trait(:german)     { locale { 'de' } }
  trait(:maldivian)  { locale { 'dv' } }
  trait(:english)    { locale { 'en' } }
  trait(:spanish)    { locale { 'es' } }
  trait(:farsi)      { locale { 'fa' } }
  trait(:finnish)    { locale { 'fi' } }
  trait(:french)     { locale { 'fr' } }
  trait(:greek)      { locale { 'gr' } }
  trait(:hebrew)     { locale { 'he' } }
  trait(:indonesian) { locale { 'id' } }
  trait(:italian)    { locale { 'it' } }
  trait(:japanese)   { locale { 'ja' } }
  trait(:polish)     { locale { 'pl' } }
  trait(:portuguese) { locale { 'pt' } }
  trait(:russian)    { locale { 'ru' } }
  trait(:slovenian)  { locale { 'sl' } }
  trait(:swedish)    { locale { 'sv' } }
  trait(:thai)       { locale { 'th' } }
  trait(:turkish)    { locale { 'tr' } }
  # and
  trait(:brazilian_portuguese) { locale { 'pt-br' } }
end
