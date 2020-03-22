FactoryBot.define do # rubocop:disable Metrics/BlockLength
  factory :locale do
    abbreviation { 'en' }
    name_in_english { 'English' }
    name { 'English' }
    language_direction { 'ltr' }
    slug { 'english' }
  end

  trait(:en) {}

  trait(:ar) do
    abbreviation { 'ar' }
    name_in_english { 'Arabic' }
    name { 'اَلْعَرَبِيَّةُ' }
    language_direction { 'rtl' }
    slug { 'alarabiyawu' }
  end

  trait(:cs) do
    abbreviation { 'cs' }
    name_in_english { 'Czech' }
    name { 'čeština' }
    language_direction { 'ltr' }
    slug { 'cestina' }
  end

  trait(:da) do
    abbreviation { 'da' }
    name_in_english { 'Danish' }
    name { 'Dansk' }
    language_direction { 'ltr' }
    slug { 'dansk' }
  end

  trait(:de) do
    abbreviation { 'de' }
    name_in_english { 'German' }
    name { 'Deutsch' }
    language_direction { 'ltr' }
    slug { 'deutsch' }
  end

  trait(:es) do
    abbreviation { 'es' }
    name_in_english { 'Spanish' }
    name { 'Español' }
    language_direction { 'ltr' }
    slug { 'espanol' }
  end

  trait(:fi) do
    abbreviation { 'fi' }
    name_in_english { 'Finnish' }
    name { 'Suomen' }
    language_direction { 'ltr' }
    slug { 'suomen' }
  end

  trait(:fr) do
    abbreviation { 'fr' }
    name_in_english { 'French' }
    name { 'Français' }
    language_direction { 'ltr' }
    slug { 'francais' }
  end

  trait(:gr) do
    abbreviation { 'gr' }
    name_in_english { 'Greek' }
    name { 'Ελληνικά' }
    language_direction { 'ltr' }
    slug { 'ellenika' }
  end

  trait(:he) do
    abbreviation { 'he' }
    name_in_english { 'Hebrew' }
    name { 'עִבְרִית' }
    language_direction { 'rtl' }
    slug { 'ibriyt' }
  end

  trait(:it) do
    abbreviation { 'it' }
    name_in_english { 'Italian' }
    name { 'Italiano' }
    language_direction { 'ltr' }
    slug { 'italiano' }
  end
  trait(:pl) do
    abbreviation { 'pl' }
    name_in_english { 'Polish' }
    name { 'Polski' }
    language_direction { 'ltr' }
    slug { 'polski' }
  end

  trait(:pt) do
    abbreviation { 'pt' }
    name_in_english { 'Portuguese' }
    name { 'Portugués' }
    language_direction { 'ltr' }
    slug { 'portugues' }
  end

  trait(:pt_br) do
    abbreviation { 'pt-br' }
    name_in_english { 'Brazilian Portuguese' }
    name { 'Português Brasileiro' }
    language_direction { 'ltr' }
    slug { 'portugues-brasileiro' }
  end

  trait(:sv) do
    abbreviation { 'sv' }
    name_in_english { 'Swedish' }
    name { 'Svenska' }
    language_direction { 'ltr' }
    slug { 'svenska' }
  end

  trait(:tr) do
    abbreviation { 'tr' }
    name_in_english { 'Turkish' }
    name { 'Türkçe' }
    language_direction { 'ltr' }
    slug { 'turkce' }
  end

  trait(:th) do
    abbreviation { 'th' }
    name_in_english { 'Thai' }
    name { 'ภาษาไทย' }
    language_direction { 'ltr' }
    slug { 'phaasaaaithy' }
  end
end
