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
end
