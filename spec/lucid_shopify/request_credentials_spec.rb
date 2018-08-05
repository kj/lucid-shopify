# frozen_string_literal: true

unauthenticated = {
  myshopify_domain: 'example.myshopify.com',
  access_token: nil,
}

authenticated = {
  myshopify_domain: 'example.myshopify.com',
  access_token: 'example',
}

RSpec.describe LucidShopify::RequestCredentials.new(unauthenticated.values.first) do
  unauthenticated.each do |k, v|
    it { is_expected.to have_attributes(k => v) }
  end
end

RSpec.describe LucidShopify::RequestCredentials.new(*authenticated.values) do
  authenticated.each do |k, v|
    it { is_expected.to have_attributes(k => v) }
  end
end
