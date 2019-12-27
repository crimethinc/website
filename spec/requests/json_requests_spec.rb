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
end
