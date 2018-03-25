# frozen_string_literal: true

require 'lucid_shopify/request'

RSpec.shared_examples 'request' do
  let(:path) { 'example/path' }

  it { is_expected.to have_attributes(credentials: credentials) }
  it { is_expected.to have_attributes(http_method: instance_of(Symbol)) }
  it { is_expected.to have_attributes(http_headers: hash_including('Accept' => 'application/json')) }
  it { is_expected.to have_attributes(url: "https://#{myshopify_domain}/admin/#{path}.json") }
  it { is_expected.to have_attributes(options: instance_of(Hash)) }

  context 'when unauthenticated' do
    it 'excludes access token header' do
      expect(request.http_headers).not_to include('X-Shopify-Access-Token')
    end
  end

  context 'when authenticated' do
    let(:credentials) { credentials_authenticated }

    it 'includes access token header' do
      expect(request.http_headers).to include('X-Shopify-Access-Token' => access_token)
    end
  end
end
