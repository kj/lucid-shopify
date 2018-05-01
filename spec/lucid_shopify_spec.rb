# frozen_string_literal: true

require 'lucid_shopify'

RSpec.describe LucidShopify do
  it 'exposes a default WebhookList' do
    expect(LucidShopify.webhooks).to be_a(LucidShopify::WebhookList)
  end

  it 'exposes a default WebhookHandlerList' do
    expect(LucidShopify.handlers).to be_a(LucidShopify::WebhookHandlerList)
  end
end
