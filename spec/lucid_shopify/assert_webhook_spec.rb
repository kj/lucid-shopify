# frozen_string_literal: true

require 'lucid_shopify/assert_webhook'

module LucidShopify
  RSpec.describe AssertWebhook do
    subject(:assert_webhook) { AssertWebhook.new }

    include_fixtures 'signed_webhook.yml'

    context 'when signature is valid' do
      let(:data) { signed_webhook['valid']['data'] }
      let(:hmac) { signed_webhook['valid']['hmac'] }

      it 'asserts signature' do
        expect { assert_webhook.(data, hmac) }.not_to raise_error
      end
    end

    context 'when signature is invalid' do
      let(:data) { signed_webhook['invalid']['data'] }
      let(:hmac) { signed_webhook['invalid']['hmac'] }

      it 'asserts signature and raises error' do
        expect { assert_webhook.(data, hmac) }.to raise_error(AssertWebhook::Error)
      end
    end
  end
end
