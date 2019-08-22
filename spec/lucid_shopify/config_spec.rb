# frozen_string_literal: true

RSpec.describe LucidShopify.config do
  it { is_expected.to have_attributes(api_key: 'fake') }
  it { is_expected.to have_attributes(shared_secret: 'fake') }
  it { is_expected.to have_attributes(scope: 'fake') }
  it { is_expected.to have_attributes(billing_callback_uri: 'fake') }
  it { is_expected.to have_attributes(webhook_uri: 'fake') }
end
