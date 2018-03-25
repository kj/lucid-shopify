# frozen_string_literal: true

require 'lucid_shopify/request_credentials'

RSpec.describe LucidShopify::RequestCredentials do
  context 'without access token' do
    let(:credentials) { credentials_unauthenticated }

    it 'has attributes (unauthenticated)' do
      expect(credentials.myshopify_domain).to eq(myshopify_domain)
      expect(credentials.access_token).to be_nil
    end
  end

  context 'with access token' do
    let(:credentials) { credentials_authenticated }

    it 'has attributes (authenticated)' do
      expect(credentials.myshopify_domain).to eq(myshopify_domain)
      expect(credentials.access_token).to eq(access_token)
    end
  end
end
