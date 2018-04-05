# frozen_string_literal: true

require 'lucid_shopify/create_all_webhooks'

require_relative 'register_webhooks_shared_examples'

RSpec.describe LucidShopify::CreateAllWebhooks do
  let(:create_webhook) { double(:call) }

  subject(:create_all_webhooks) do
    LucidShopify::CreateAllWebhooks.new(
      create_webhook: create_webhook
    )
  end

  include_examples 'register webhooks'

  it 'creates all registered webhooks' do
    expect(LucidShopify.webhooks.length).to be(webhooks_registered.length)

    LucidShopify.webhooks.each do |webhook|
      expect(create_webhook).to receive(:call).with(credentials, webhook)
    end

    create_all_webhooks.(credentials)
  end
end
