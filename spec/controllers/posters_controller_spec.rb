require 'rails_helper'

RSpec.describe PostersController do
  render_views

  describe 'GET #index' do
    context 'when a published poster has no images attached' do
      it 'renders without raising "Nil location provided"' do
        create(
          :poster,
          slug:               'no-image-poster',
          publication_status: 'published',
          published_at:       1.day.ago,
          locale:             'en'
        )

        expect { get :index }.not_to raise_error
        expect(response).to be_successful
      end
    end
  end
end
