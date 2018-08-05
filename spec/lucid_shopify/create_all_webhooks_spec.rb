# frozen_string_literal: true

require_relative 'register_webhooks_shared_context'

module LucidShopify
  RSpec.describe CreateAllWebhooks do
    let(:create_webhook) { instance_double('CreateWebhook') }

    subject(:create_all_webhooks) do
      CreateAllWebhooks.new(
        create_webhook: create_webhook
      )
    end

    include_context 'register webhooks'

    it 'creates all registered webhooks' do
      expect(LucidShopify.webhooks.count).to be(webhooks['registered'].length)

      LucidShopify.webhooks.each do |webhook|
        expect(create_webhook).to receive(:call).with(credentials, webhook)
      end

      create_all_webhooks.(credentials)
    end
  end
end
