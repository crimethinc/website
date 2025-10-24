require 'rails_helper'

describe 'Tools Pages' do
  before do
    Current.theme = '2017'
  end

  it 'renders published logos calling /logos' do
    # Create a simple test image file
    test_image = fixture_file_upload 'spec/fixtures/files/test_image.jpg', 'image/jpeg'

    logo = create(:logo,
                  title:              'published',
                  published_at:       1.day.ago,
                  publication_status: 'published')

    logo.image_jpg.attach test_image

    create(:logo,
           title:              'not live',
           published_at:       1.day.from_now,
           publication_status: 'published')

    create(:logo,
           title:              'draft',
           publication_status: 'draft')

    visit '/logos'

    expect(page).to have_content 'published'
    expect(page).to have_no_content 'draft'
    expect(page).to have_no_content 'not live'
  end

  it 'renders published stickers calling /stickers', skip: 'Fix this test' do
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

  it 'renders published zines calling /zines' do
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

  it 'renders published posters calling /posters', skip: 'Fix this test' do
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

  it 'renders published videos calling /videos' do
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
