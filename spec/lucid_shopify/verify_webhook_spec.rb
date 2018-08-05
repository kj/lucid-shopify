# frozen_string_literal: true

module LucidShopify
  RSpec.describe VerifyWebhook do
    subject(:verify_webhook) { VerifyWebhook.new }

    include_fixtures 'signed_webhook.yml'

    context 'when signature is valid' do
      let(:data) { signed_webhook['valid']['data'] }
      let(:hmac) { signed_webhook['valid']['hmac'] }

      it 'verifies signature' do
        expect { verify_webhook.(data, hmac) }.not_to raise_error
      end
    end

    context 'when signature is invalid' do
      let(:data) { signed_webhook['invalid']['data'] }
      let(:hmac) { signed_webhook['invalid']['hmac'] }

      it 'verifies signature and raises error' do
        expect { verify_webhook.(data, hmac) }.to raise_error(VerifyWebhook::Error)
      end
    end
  end
end
