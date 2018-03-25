# frozen_string_literal: true

require 'lucid_shopify/config'

RSpec.describe LucidShopify.config do
  it { is_expected.to have_attributes(api_key: 'fake') }
  it { is_expected.to have_attributes(shared_secret: 'fake') }
  it { is_expected.to have_attributes(scope: 'fake') }
  it { is_expected.to have_attributes(billing_callback_uri: 'fake') }
  it { is_expected.to have_attributes(webhook_uri: 'fake') }

  it 'raises an error when unset' do
    LucidShopify.config = nil

    expect { LucidShopify.config.api_key }.to raise_error(LucidShopify::NotConfiguredError)

    LucidShopify.config = subject
  end
end

RSpec.describe LucidShopify do
  it { is_expected.to have_attributes(api_key: 'fake') }
  it { is_expected.to have_attributes(shared_secret: 'fake') }
  it { is_expected.to have_attributes(scope: 'fake') }
  it { is_expected.to have_attributes(billing_callback_uri: 'fake') }
  it { is_expected.to have_attributes(webhook_uri: 'fake') }
end
