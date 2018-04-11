# frozen_string_literal: true

require 'lucid_shopify/delegate_webhooks'

module LucidShopify
  RSpec.describe DelegateWebhooks do
    let(:handlers) do
      [
        double('handler 1 of 3'),
        double('handler 2 of 3'),
        double('handler 3 of 3'),
      ]
    end
    let(:webhook) { instance_double('Webhook', :topic => webhook_topic) }
    let(:webhook_topic) { 'orders/create' }

    subject(:delegate_webhooks) { DelegateWebhooks.new }

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
end
