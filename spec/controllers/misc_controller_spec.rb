require 'rails_helper'

RSpec.describe MiscController do
  # get 'manifest.json',  to: 'misc#mainfest_json'
  # get 'opensearch.xml', to: 'misc#opensearch_xml'
  describe 'GET #manifest_json' do
    it 'responds successfully' do
      get :manifest_json

      expect(response).to be_successful
    end

    it 'responds successfully when the client only accepts text/html' do
      request.headers['Accept'] = 'text/html, text/plain'
      get :manifest_json

      expect(response).to be_successful
      expect(response.content_type).to start_with 'application/json'
    end
  end

  describe 'GET #opensearch_xml' do
    it 'responds successfully' do
      get :opensearch_xml

      expect(response).to be_successful
    end

    it 'responds successfully when the client only accepts text/html' do
      request.headers['Accept'] = 'text/html, text/plain'
      get :opensearch_xml

      expect(response).to be_successful
      expect(response.content_type).to start_with 'application/xml'
    end
  end
end
