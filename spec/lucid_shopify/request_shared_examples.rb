# frozen_string_literal: true

require 'lucid_shopify/request'
require 'lucid_shopify/request_credentials'

RSpec.shared_examples 'request' do
  let(:path) { 'example/path' }

  it 'has attributes' do
    expect(request.credentials).to be_a(LucidShopify::RequestCredentials)
    expect(request.http_method).to be_a(Symbol)
    expect(request.http_headers).to include('Accept' => 'application/json')
    expect(request.url).to eq("https://#{myshopify_domain}/admin/#{path}.json")
    expect(request.options).to be_a(Hash) # client options
  end

  context 'when unauthenticated' do
    let(:credentials) { credentials_unauthenticated }

    it 'excludes access token header' do
      expect(request.http_headers).not_to include(
        'X-Shopify-Access-Token'
      )
    end
  end

  context 'when authenticated' do
    let(:credentials) { credentials_authenticated }

    it 'includes access token header' do
      expect(request.http_headers).to include(
        'X-Shopify-Access-Token' => access_token
      )
    end
  end
end
