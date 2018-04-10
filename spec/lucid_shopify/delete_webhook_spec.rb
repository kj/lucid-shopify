# frozen_string_literal: true

require 'lucid_shopify/delete_webhook'

RSpec.describe LucidShopify::DeleteWebhook do
  let(:client) { instance_double('LucidShopify::Client') }
  let(:id) { 1 }

  subject(:delete_webhook) do
    LucidShopify::DeleteWebhook.new(
      client: client
    )
  end

  it 'deletes a webhook via the API' do
    expect(client).to receive(:delete).with(credentials, "webhooks/#{id}")

    delete_webhook.(credentials, id)
  end
end
