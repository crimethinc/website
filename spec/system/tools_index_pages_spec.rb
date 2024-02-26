require 'rails_helper'

describe 'Tools Pages' do
  before do
    Current.theme = '2017'
  end

  it 'Renders published logos calling /logos' do
    create(:logo,
           title:              'published',
           published_at:       1.day.ago,
           publication_status: 'published')

    create(:logo,
           title:              'not live',
           published_at:       1.day.from_now,
           publication_status: 'published')

    create(:logo,
           title:              'draft',
           publication_status: 'draft')

    # TEMP: re-enable after figuring out tests with Active Storage assets
    # visit '/logos'
    #
    # expect(page).to have_content 'published'
    # expect(page).not_to have_content 'draft'
    # expect(page).not_to have_content 'not live'
  end

  it 'Renders published stickers calling /stickers' do
    create(:sticker,
           title:              'published',
           published_at:       1.day.ago,
           publication_status: 'published')

    create(:sticker,
           title:              'not live',
           published_at:       1.day.from_now,
           publication_status: 'published')

    create(:sticker,
           title:              'draft',
           publication_status: 'draft')

    # TEMP: re-enable after figuring out tests with Active Storage assets
    # visit '/stickers'
    #
    # expect(page).to have_content 'published'
    # expect(page).not_to have_content 'draft'
    # expect(page).not_to have_content 'not live'
  end

  it 'Renders published zines calling /zines' do
    create(:zine,
           title:              'published',
           published_at:       1.day.ago,
           publication_status: 'published')

    create(:zine,
           title:              'not live',
           published_at:       1.day.from_now,
           publication_status: 'published')

    create(:zine,
           title:              'draft',
           publication_status: 'draft')

    visit '/zines'

    expect(page).to have_content 'published'
    expect(page).to have_no_content 'draft'
    expect(page).to have_no_content 'not live'
  end

  it 'Renders published posters calling /posters' do
    create(:poster,
           title:              'published',
           published_at:       1.day.ago,
           publication_status: 'published')

    create(:poster,
           title:              'not live',
           published_at:       1.day.from_now,
           publication_status: 'published')

    create(:poster,
           title:              'draft',
           publication_status: 'draft')

    # TEMP: re-enable after figuring out tests with Active Storage assets
    # visit '/posters'
    #
    # expect(page).to have_content 'published'
    # expect(page).not_to have_content 'draft'
    # expect(page).not_to have_content 'not live'
  end

  it 'Renders published videos calling /videos' do
    create(:video,
           title:              'published',
           published_at:       1.day.ago,
           publication_status: 'published')

    create(:video,
           title:              'not live',
           published_at:       1.day.from_now,
           publication_status: 'published')

    create(:video,
           title:              'draft',
           publication_status: 'draft')

    visit '/videos'

    expect(page).to have_content 'published'
    expect(page).to have_no_content 'not live'
    expect(page).to have_no_content 'draft'
  end
end
