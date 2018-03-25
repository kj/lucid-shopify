# frozen_string_literal: true

require 'lucid_shopify/request_credentials'

unauthenticated = {
  myshopify_domain: 'example.myshopify.com',
  access_token: nil,
}

authenticated = {
  myshopify_domain: 'example.myshopify.com',
  access_token: 'example',
}

RSpec.describe LucidShopify::RequestCredentials.new(unauthenticated.values.first) do
  it { is_expected.to have_attributes(unauthenticated) }
end

RSpec.describe LucidShopify::RequestCredentials.new(*authenticated.values) do
  it { is_expected.to have_attributes(authenticated) }
end
