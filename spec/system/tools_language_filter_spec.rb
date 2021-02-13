require 'rails_helper'

describe 'filter[lang] for Tools Pages' do # rubocop:disable RSpec/DescribeClass
  after(:all) { Zine.destroy_all } # rubocop:disable RSpec/BeforeAfterAll

  before(:all) do # rubocop:disable RSpec/BeforeAfterAll
    Current.theme = '2017'

    create(:zine, :english, :live, title: 'english_zine')
    create(:zine, :spanish, :live, title: 'spanish_zine')
    create(:zine, :thai, :live, title: 'thai_zine')
  end

  let(:filters) { {} }

  context 'when filtered with a valid value' do
    let(:filters) { { filter: { lang: :es } } }

    it 'is expected to only shpow the filtered zines' do
      visit zines_path(filters)

      expect(page).to have_content 'spanish_zine'
      expect(page).not_to have_content 'english_zine'
      expect(page).not_to have_content 'thai_zine'
    end
  end

  context 'when filtered with a invalid locale' do
    let(:filters) { { filter: { lang: 'foo' } } }

    it 'is expected to show no zines' do
      visit zines_path(filters)

      expect(page).not_to have_content 'english_zine'
      expect(page).not_to have_content 'spanish_zine'
      expect(page).not_to have_content 'thai_zine'
    end
  end

  context 'when there is no filter' do
    let(:filters) { {} }

    it 'is expected to show all zines' do
      visit zines_path(filters)

      expect(page).to have_content 'english_zine'
      expect(page).not_to have_content 'spanish_zine'
      expect(page).not_to have_content 'thai_zine'
    end
  end
end
