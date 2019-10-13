# frozen_string_literal: true

module Lucid
  module Shopify
    RSpec.describe CreateWebhook do
      let(:client) { instance_double('Client') }
      let(:data) { {webhook: {**webhook, address: Shopify.config.webhook_uri}} }

      subject(:create_webhook) do
        CreateWebhook.new(
          client: client
        )
      end

      context 'without fields' do
        let(:webhook) { {topic: 'orders/create'} }

        it 'creates a webhook via the API' do
          expect(client).to receive(:post_json).with(credentials, 'webhooks', data)

          create_webhook.(credentials, webhook)
        end
      end

      context 'with fields' do
        let(:webhook) { {topic: 'orders/create', fields: 'id,tags'} }

        it 'creates a webhook via the API' do
          expect(client).to receive(:post_json).with(credentials, 'webhooks', data)

          create_webhook.(credentials, webhook)
        end
      end
    end
  end
end
