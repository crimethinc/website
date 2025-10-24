require 'rails_helper'

describe 'Tools pages' do
  before do
    Current.theme = '2017'
  end

  it 'renders published logos calling /logos' do
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

    visit :logos

    expect(page).to have_content 'published'
    expect(page).to have_no_content 'draft'
    expect(page).to have_no_content 'not live'
  end

  it 'renders published stickers calling /stickers' do
    first_test_image = fixture_file_upload 'spec/fixtures/files/test_image.jpg', 'image/jpeg'
    second_test_image = fixture_file_upload 'spec/fixtures/files/test_image.jpg', 'image/jpeg'
    third_test_image = fixture_file_upload 'spec/fixtures/files/test_image.jpg', 'image/jpeg'

    first_sticker = create(:sticker,
                           title:              'published',
                           published_at:       1.day.ago,
                           publication_status: 'published')

    second_sticker = create(:sticker,
                            title:              'not live',
                            published_at:       1.day.from_now,
                            publication_status: 'published')

    third_sticker = create(:sticker,
                           title:              'draft',
                           publication_status: 'draft')

    first_sticker.image_front_color_image.attach first_test_image
    second_sticker.image_front_color_image.attach second_test_image
    third_sticker.image_front_color_image.attach third_test_image

    visit :stickers

    expect(page).to have_content 'published'
    expect(page).to have_no_content 'draft'
    expect(page).to have_no_content 'not live'
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

    visit :zines

    expect(page).to have_content 'published'
    expect(page).to have_no_content 'draft'
    expect(page).to have_no_content 'not live'
  end

  it 'renders published posters calling /posters' do
    first_test_pdf    = fixture_file_upload('spec/fixtures/files/test_pdf.pdf',   'image/pdf')
    first_test_image  = fixture_file_upload('spec/fixtures/files/test_image.jpg', 'image/jpg')
    second_test_pdf   = fixture_file_upload('spec/fixtures/files/test_pdf.pdf',   'image/pdf')
    second_test_image = fixture_file_upload('spec/fixtures/files/test_image.jpg', 'image/jpg')
    third_test_pdf    = fixture_file_upload('spec/fixtures/files/test_pdf.pdf',   'image/pdf')
    third_test_image  = fixture_file_upload('spec/fixtures/files/test_image.jpg', 'image/jpg')

    first_poster = create(:poster,
                          title:              'published',
                          published_at:       1.day.ago,
                          publication_status: 'published')

    second_poster = create(:poster,
                           title:              'not live',
                           published_at:       1.day.from_now,
                           publication_status: 'published')

    third_poster = create(:poster,
                          title:              'draft',
                          publication_status: 'draft')

    first_poster.image_front_color_download.attach first_test_pdf
    first_poster.image_front_color_image.attach first_test_image
    second_poster.image_front_color_download.attach second_test_pdf
    second_poster.image_front_color_image.attach second_test_image
    third_poster.image_front_color_download.attach third_test_pdf
    third_poster.image_front_color_image.attach third_test_image

    visit :posters

    expect(page).to have_content 'published'
    expect(page).to have_no_content 'draft'
    expect(page).to have_no_content 'not live'
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

    visit :videos

    expect(page).to have_content 'published'
    expect(page).to have_no_content 'not live'
    expect(page).to have_no_content 'draft'
  end
end
