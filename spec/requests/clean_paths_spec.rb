require 'rails_helper'
require 'rake'
Rails.application.load_tasks

RSpec.describe 'Rack::CleanPath', type: :request do
  it 'redirects according to path clean up rules' do
    get 'http://example.com/about/faq.html'

    expect(response.header['Location']).to eq('/about/faq')
  end

  it 'redirects with query string' do
    get 'http://example.com/about/faq.html?test=true'

    expect(response.header['Location']).to eq('/about/faq?test=true')
  end

  it 'does not strip .xml extension from sitemap.xml' do
    Rake::Task['sitemap:refresh:no_ping'].invoke

    get 'http://example.com/sitemap.xml.gz'

    expect(response.status).to eq(200)
    expect(response.header['Location']).to be_nil
    expect(response.body).not_to be_empty

    Rake::Task['sitemap:clean'].invoke
  end
end
