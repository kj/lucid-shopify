# frozen_string_literal: true

require 'lucid_shopify/delegate_webhooks'

RSpec.describe LucidShopify::DelegateWebhooks do
  let(:handlers) do
    [
      double('handler 1 of 3'),
      double('handler 2 of 3'),
      double('handler 3 of 3'),
    ]
  end
  let(:webhook) { double('webhook', :topic => webhook_topic) }
  let(:webhook_topic) { 'orders/create' }

  subject(:delegate_webhooks) { LucidShopify::DelegateWebhooks.new }

  context 'when not registered' do
    it 'delegates to any handlers' do
      handlers.each do |handler|
        expect(handler).not_to receive(:call).with(webhook)
      end

      delegate_webhooks.(webhook)
    end
  end

  context 'when registered' do
    before do
      handlers.each do |handler|
        delegate_webhooks.register(webhook_topic, handler)
      end
    end

    it 'delegates to any handlers' do
      handlers.each do |handler|
        expect(handler).to receive(:call).with(webhook)
      end

      delegate_webhooks.(webhook)
    end
  end
end
