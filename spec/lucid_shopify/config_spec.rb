# frozen_string_literal: true

require 'lucid_shopify/config'

RSpec.describe LucidShopify::Config do
  let(:config) { LucidShopify.config }

  it 'has attributes' do
    expect(config.api_key).to eq('fake')
    expect(config.shared_secret).to eq('fake')
    expect(config.scope).to eq('fake')
    expect(config.billing_callback_uri).to eq('fake')
    expect(config.webhook_uri).to eq('fake')
  end

  it 'has attributes forwarded from the root module' do
    expect(LucidShopify.api_key).to eq('fake')
    expect(LucidShopify.shared_secret).to eq('fake')
    expect(LucidShopify.scope).to eq('fake')
    expect(LucidShopify.billing_callback_uri).to eq('fake')
    expect(LucidShopify.webhook_uri).to eq('fake')
  end

  it 'raises an error when unset' do
    old_config = config

    LucidShopify.config = nil
    expect { LucidShopify.config.api_key }.to raise_error(LucidShopify::NotConfiguredError)
    LucidShopify.config = old_config
  end
end
