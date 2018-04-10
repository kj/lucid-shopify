# frozen_string_literal: true

require 'lucid_shopify/delete_all_webhooks'

require_relative 'register_webhooks_shared_examples'

RSpec.describe LucidShopify::DeleteAllWebhooks do
  let(:client) { instance_double('LucidShopify::Client') }
  let(:delete_webhook) { instance_double('LucidShopify::DeleteWebhook') }

  subject(:delete_all_webhooks) do
    LucidShopify::DeleteAllWebhooks.new(
      client: client,
      delete_webhook: delete_webhook
    )
  end

  include_examples 'register webhooks'

  let(:data) { {'webhooks' => webhooks_shopify} }

  it 'deletes any existing webhooks' do
    expect(client).to receive(:get).and_return(data)

    webhooks_shopify.each do |webhook|
      expect(delete_webhook).to receive(:call).with(credentials, webhook['id'])
    end

    delete_all_webhooks.(credentials)
  end
end
