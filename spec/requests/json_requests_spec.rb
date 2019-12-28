require 'rails_helper'

describe 'JsonRequests', type: :request do
  let(:json_headers) { { ACCEPT: 'application/json', HTTP_ACCEPT: 'application/json', CONTENT_TYPE: 'application/json' } }
  let(:expected_error) { "Y'all requested JSON, but we don't do that" }

  it 'returns a 406 response to clients requesting json' do
    get root_path, headers: json_headers

    expect(response.content_type).to eq 'application/json'
    expect(status).to eq 406
  end

  it 'returns an error message in the body' do
    get root_path, headers: json_headers

    error_message = JSON.parse(body)['errors'].first.dig('detail')
    expect(error_message).to eq expected_error
  end

  context 'when there is no HTTP_ACCEPT header' do
    let(:json_headers) { { HTTP_ACCEPT: nil } }

    it 'continues through to the regular app' do
      get root_path, headers: json_headers

      expect(response.content_type).to eq 'text/html'
      expect(status).to eq 301
    end
  end

  context 'when hitting the article polling endpoint' do
    let(:published_at) { 5.minutes.ago }
    let(:collection) { create(:article, title: 'test', publication_status: 'published', published_at: published_at) }
    let!(:article) do
      create(:article, title: 'collection', collection_id: collection.id, publication_status: 'published', published_at: published_at)
    end

    it 'still returns collections' do
      get "/articles/#{collection.id}/collection_posts", params: { published_at: published_at.to_i }, headers: json_headers
      follow_redirect!

      article_title = JSON.parse(response.body)['posts'].first['title']
      expect(article_title).to eq article.title
    end
  end

  context 'when hitting the json manifet path' do
    it 'returns the manifest' do
      get '/manifest.json', headers: json_headers
      follow_redirect!
      expect(status).to eq 200
    end
  end

  context 'when hitting the JSON RSS feed' do
    before { create(:article, content: 'foo') }

    it 'returns the feed' do
      get '/feed.json', headers: json_headers
      follow_redirect!

      expect(status).to eq 200
      expect(response.body).to include 'foo'
    end
  end
end
