require 'rails_helper'

RSpec.describe 'Rack::CleanPath', type: :request do
  it 'redirects according to path clean up rules' do
    get 'http://example.com/about/faq.html'

    expect(response.header['Location']).to eq('/about/faq')
  end

  it 'redirects with query string' do
    get 'http://example.com/about/faq.html?test=true'

    expect(response.header['Location']).to eq('/about/faq?test=true')
  end

  it 'do not strip .xml extension for sitemap.xml' do
    get 'http://example.com/sitemap.xml'

    expect(response.status).to eq(200)
    expect(response.header['Location']).to be_nil
    expect(response.body).to eq('<sitemap>test</sitemap>')
  end
end
