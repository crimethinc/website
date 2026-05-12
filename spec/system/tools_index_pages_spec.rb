require 'rails_helper'

describe 'Tools pages' do
  before {  Current.theme = '2017' }

  def test_image = fixture_file_upload 'spec/fixtures/files/test_image.jpg', 'image/jpeg'
  def test_pdf   = fixture_file_upload('spec/fixtures/files/test_pdf.pdf',   'image/pdf')

  describe '/logos' do
    it 'renders published logos calling /logos' do
      logo = create(:logo, :live, title: 'published')
      logo.image_jpg.attach test_image

      create(:logo, :published, :not_live, title: 'not live')
      create(:logo, :draft, title: 'draft')

      visit :logos

      expect(page).to have_text 'published'
      expect(page).to have_no_text 'draft'
      expect(page).to have_no_text 'not live'
    end
  end

  describe '/stickers' do
    it 'renders published stickers calling /stickers' do
      first_sticker = create(:sticker, :live, title: 'published')
      second_sticker = create(:sticker, :not_live, title: 'not live')
      third_sticker = create(:sticker, :draft, title: 'draft')

      first_sticker.image_front_color_image.attach test_image
      second_sticker.image_front_color_image.attach test_image
      third_sticker.image_front_color_image.attach test_image

      visit :stickers

      expect(page).to have_text 'published'
      expect(page).to have_no_text 'draft'
      expect(page).to have_no_text 'not live'
    end
  end

  describe '/zines' do
    it 'renders published zines calling /zines' do
      create(:zine, :live, title: 'published')
      create(:zine, :not_live, title: 'not live')
      create(:zine, :draft, title: 'draft')

      visit :zines

      expect(page).to have_text 'published'
      expect(page).to have_no_text 'draft'
      expect(page).to have_no_text 'not live'
    end
  end

  describe '/posters' do
    it 'renders published posters calling /posters' do
      first_poster = create(:poster, :live, title: 'published')
      second_poster = create(:poster, :not_live, title: 'not live')
      third_poster = create(:poster, :draft, title: 'draft')

      first_poster.image_front_color_download.attach test_pdf
      first_poster.image_front_color_image.attach test_image
      second_poster.image_front_color_download.attach test_pdf
      second_poster.image_front_color_image.attach test_image
      third_poster.image_front_color_download.attach test_pdf
      third_poster.image_front_color_image.attach test_image

      visit :posters

      expect(page).to have_text 'published'
      expect(page).to have_no_text 'draft'
      expect(page).to have_no_text 'not live'
    end
  end

  describe '/videos' do
    it 'renders published videos calling /videos' do
      create(:video, :live, title: 'published')
      create(:video, :not_live, title: 'not live')
      create(:video, :draft, title: 'draft')
    
      visit :videos

      expect(page).to have_text 'published'
      expect(page).to have_no_text 'not live'
      expect(page).to have_no_text 'draft'
    end
  end
end
