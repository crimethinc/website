require 'rails_helper'

describe 'Language Landing Page' do
  before do
    create(:article)
    create(:article, :spanish)
    create(:article, :german)
    create(:article, :danish)
    create(:article, :finnish)
    create(:article, :french)
    create(:article, :greek)
    create(:article, :hebrew)
    create(:article, :italian)
    create(:article, :swedish)
    create(:article, :turkish)
    create(:article, :portuguese)
    create(:article, :polish)
    create(:article, :brazilian_portuguese)
  end

  it 'has a link for every language' do
    visit '/languages'

    within '#locales' do
      links = all('a')

      # 3 versions of every language's link
      expect(links.count).to eq(Article.count * 3)
    end
  end

  it 'Renders the landing page with counts and links to specific languages' do
    visit '/languages'

    # 3 links per row, collect text for each into an array of arrays
    link_triplets = []
    within '#locales' do
      all('tr').each do |row|
        link_triplets << row.all('a').map(&:text)
      end
    end

    link_triplets.each do |triple|
      english = triple.last
      triple.each do |link_text|
        click_on link_text, match: :first
        expect(page).to have_content english
        visit '/languages'
      end
    end
  end

  it 'does NOT show a language if there are no published articles' do
    visit '/languages'

    within('#locales') { expect(page).to have_content 'Italian' }

    # unpublish the italian article
    Article.where(locale: 'it').first.update!(publication_status: 'draft')

    visit '/languages'

    within('#locales') { expect(page).not_to have_content 'Italian' }
  end

  it 'redirects to the language index page if a language is not found' do
    visit '/languages/foo'

    expect(page).to have_current_path languages_path
  end
end
