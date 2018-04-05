# frozen_string_literal: true

require 'lucid_shopify/create_webhook'

RSpec.describe LucidShopify::CreateWebhook do
  let(:client) { double.as_null_object }
  let(:data) { {webhook: {**webhook, address: LucidShopify.config.webhook_uri}} }

  subject(:create_webhook) do
    LucidShopify::CreateWebhook.new(
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
    let(:webhook) { {topic: 'orders/create', fields: 'id,line_items'} }

    it 'creates a webhook via the API' do
      expect(client).to receive(:post_json).with(credentials, 'webhooks', data)

      create_webhook.(credentials, webhook)
    end
  end
end
