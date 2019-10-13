# frozen_string_literal: true

module Lucid
  module Shopify
    RSpec.describe DeleteWebhook do
      let(:client) { instance_double('Client') }
      let(:id) { 1 }

      subject(:delete_webhook) do
        DeleteWebhook.new(
          client: client
        )
      end

      it 'deletes a webhook via the API' do
        expect(client).to receive(:delete).with(credentials, "webhooks/#{id}")

        delete_webhook.(credentials, id)
      end
    end
  end
end
