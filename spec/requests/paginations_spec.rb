require 'rails_helper'

# rubocop:disable RSpec/DescribeClass
RSpec.describe 'Pagination Redirects' do
  # rubocop:enable RSpec/DescribeClass
  describe 'home page articles' do
    it 'renders a numbered page that has no format extension' do
      get 'http://example.com/page/2'

      expect(response).to have_http_status(:ok)
    end

    it 'redirects a malformed page number to the cleaned one' do
      get 'http://example.com/page/2x'

      expect(response).to redirect_to('/page/2')
    end

    it 'renders a feed format page without redirecting' do
      get 'http://example.com/page/2.atom'

      expect(response).to have_http_status(:ok)
    end
  end

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
