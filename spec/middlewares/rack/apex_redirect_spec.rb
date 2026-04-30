require 'rails_helper'

RSpec.describe Rack::ApexRedirect do
  let(:inner_app) { ->(_env) { [200, {}, ['ok']] } }
  let(:middleware) { described_class.new(inner_app) }

  context 'when the request host has a www. subdomain' do
    let(:env) { Rack::MockRequest.env_for('http://www.crimethinc.com/about') }

    it 'redirects to the apex domain' do
      status, headers, _body = middleware.call(env)

      expect(status).to eq 301
      expect(headers['Location']).to eq 'http://crimethinc.com/about'
    end
  end

  context 'when the request host is the apex domain' do
    let(:env) { Rack::MockRequest.env_for('http://crimethinc.com/about') }

    it 'passes through to the inner app' do
      status, _headers, body = middleware.call(env)

      expect(status).to eq 200
      expect(body).to eq ['ok']
    end
  end

  context 'when the request host is missing' do
    let(:env) { Rack::MockRequest.env_for('http://example.com/').merge('HTTP_HOST' => nil, 'SERVER_NAME' => nil) }

    it 'passes through without raising' do
      expect { middleware.call(env) }.not_to raise_error
    end
  end
end
