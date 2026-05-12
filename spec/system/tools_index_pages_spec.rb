require 'rails_helper'

describe 'Tools pages' do
  before {  Current.theme = '2017' }

  def test_image = fixture_file_upload 'spec/fixtures/files/test_image.jpg', 'image/jpeg'
  def test_pdf   = fixture_file_upload('spec/fixtures/files/test_pdf.pdf',   'image/pdf')

  shared_examples "renders published tool type for the path" do |tool|
    let(:tool) { tool.to_sym }

    it "renders published logos calling /#{tool}" do
      visit tool

      expect(page).to have_text 'published'
      expect(page).to have_no_text 'draft'
      expect(page).to have_no_text 'not live'
    end
  end

  describe '/logos' do
    let(:uploads) { [[:image_jpg, test_image]] }

    before do
      create(:logo, :live, title: 'published', uploads: uploads)
      create(:logo, :published, :not_live, title: 'not live', uploads: uploads)
      create(:logo, :draft, title: 'draft', uploads: uploads)
    end

    it_behaves_like "renders published tool type for the path", :logos
  end

  describe '/stickers' do
    let(:uploads) { [[:image_front_color_image, test_image]] }

    before do
      create(:sticker, :live, title: 'published', uploads: uploads)
      create(:sticker, :not_live, title: 'not live', uploads: uploads)
      create(:sticker, :draft, title: 'draft', uploads: uploads)
    end

    it_behaves_like "renders published tool type for the path", :stickers
  end

  describe '/zines' do
    let(:uploads) { [] }

    before do
      create(:zine, :live, title: 'published', uploads: uploads)
      create(:zine, :not_live, title: 'not live', uploads: uploads)
      create(:zine, :draft, title: 'draft', uploads: uploads)
    end

    it_behaves_like "renders published tool type for the path", :zines
  end

  describe '/posters' do
    let(:uploads) do
      [
        [:image_front_color_download, test_pdf],
        [:image_front_color_image, test_image]
      ]
    end

    before do
      create(:poster, :live, title: 'published', uploads: uploads)
      create(:poster, :not_live, title: 'not live', uploads: uploads)
      create(:poster, :draft, title: 'draft', uploads: uploads)
    end

    it_behaves_like "renders published tool type for the path", :posters
  end

  describe '/videos' do
    let(:uploads) { [[:image_poster_frame, test_image]] }

    before do
      create(:video, :live, title: 'published', uploads: uploads)
      create(:video, :not_live, title: 'not live', uploads: uploads)
      create(:video, :draft, title: 'draft', uploads: uploads)
    end

    it_behaves_like "renders published tool type for the path", :videos
  end
end
