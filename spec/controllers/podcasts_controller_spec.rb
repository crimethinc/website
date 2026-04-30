require 'rails_helper'

RSpec.describe PodcastsController do
  describe 'GET #show' do
    context 'when the podcast exists' do
      let(:podcast) { create(:podcast) }

      it 'renders successfully' do
        get :show, params: { slug: podcast.slug }

        expect(response).to be_successful
      end
    end

    context 'when the slug does not match any podcast' do
      it 'redirects to the podcasts index instead of raising' do
        get :show, params: { slug: 'no-such-podcast' }

        expect(response).to redirect_to(podcasts_path)
      end
    end
  end
end
