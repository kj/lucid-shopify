# frozen_string_literal: true

require 'lucid/shopify'

module Lucid
  RSpec.describe Shopify do
    it 'exposes a default WebhookList' do
      expect(Shopify.webhooks).to be_a(Shopify::WebhookList)
    end

    it 'exposes a default WebhookHandlerList' do
      expect(Shopify.handlers).to be_a(Shopify::WebhookHandlerList)
    end
  end
end
