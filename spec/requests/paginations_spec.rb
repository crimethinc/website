require 'rails_helper'

RSpec.describe 'Pagination Redirects', type: :request do
  describe 'article archives' do
    it 'redirects on page 1' do
      get 'http://example.com/2017/01/01/page/1'

      expect(response).to redirect_to('/2017/01/01/')
    end

    it 'redirects when no page number given' do
      get 'http://example.com/2017/01/01/page'

      expect(response).to redirect_to('/2017/01/01/')
    end
  end

  describe 'categories' do
    it 'redirects on page 1' do
      get 'http://example.com/categories/slug/page/1'

      expect(response).to redirect_to('/categories/slug/')
    end

    it 'redirects when no page number given' do
      get 'http://example.com/categories/slug/page'

      expect(response).to redirect_to('/categories/slug/')
    end
  end

  describe 'tags' do
    it 'redirects on page 1' do
      get 'http://example.com/tags/slug/page/1'

      expect(response).to redirect_to('/tags/slug/')
    end

    it 'redirects when no page number given' do
      get 'http://example.com/tags/slug/page'

      expect(response).to redirect_to('/tags/slug/')
    end
  end

  describe 'videos' do
    it 'redirects on page 1' do
      get 'http://example.com/videos/page/1'

      expect(response).to redirect_to('/videos/')
    end

    it 'redirects when no page number given' do
      get 'http://example.com/videos/page'

      expect(response).to redirect_to('/videos/')
    end
  end

  describe 'admin' do
    it 'redirects on page 1' do
      get 'http://example.com/admin/videos/page/1'

      expect(response).to redirect_to('/admin/videos/')
    end

    it 'redirects when no page number given' do
      get 'http://example.com/admin/videos/page'

      expect(response).to redirect_to('/admin/videos/')
    end
  end
end
