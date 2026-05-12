require 'rails_helper'

describe 'Tools pages' do
  before {  Current.theme = '2017' }

  def test_image = fixture_file_upload 'spec/fixtures/files/test_image.jpg', 'image/jpeg'
  def test_pdf   = fixture_file_upload 'spec/fixtures/files/test_pdf.pdf',   'image/pdf'

  shared_examples "renders published tool type for the path" do |tool|
    let(:uploads) { [] }

    before do
      create(tool, :live, title: 'published', uploads: uploads)
      create(tool, :published, :not_live, title: 'not live', uploads: uploads)
      create(tool, :draft, title: 'draft', uploads: uploads)
    end

    it "renders published logos calling /#{tool.to_s.pluralize}" do
      visit tool.to_s.pluralize.to_sym

      expect(page).to have_text 'published'
      expect(page).to have_no_text 'draft'
      expect(page).to have_no_text 'not live'
    end
  end

  describe '/logos' do
    it_behaves_like "renders published tool type for the path", :logo do
      let(:uploads) { [[:image_jpg, test_image]] }
    end
  end

  describe '/stickers' do
    it_behaves_like "renders published tool type for the path", :sticker do
      let(:uploads) { [[:image_front_color_image, test_image]] }
    end
  end

  describe '/zines' do
    it_behaves_like "renders published tool type for the path", :zine do
      let(:uploads) { [] }
    end
  end

  describe '/posters' do
    it_behaves_like "renders published tool type for the path", :poster do
      let(:uploads) do
        [
          [:image_front_color_download, test_pdf],
          [:image_front_color_image, test_image]
        ]
      end
    end
  end

  describe '/videos' do
    it_behaves_like "renders published tool type for the path", :video do
      let(:uploads) { [[:image_poster_frame, test_image]] }
    end
  end
end
