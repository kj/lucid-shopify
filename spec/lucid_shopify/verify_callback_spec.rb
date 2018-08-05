# frozen_string_literal: true

module LucidShopify
  RSpec.describe VerifyCallback do
    subject(:verify_callback) { VerifyCallback.new }

    include_fixtures 'signed_callback.yml'

    context 'when signature is valid' do
      let(:params) { signed_callback['valid'] }

      it 'verifies signature' do
        expect { verify_callback.(params) }.not_to raise_error
      end
    end

    context 'when signature is invalid' do
      let(:params) { signed_callback['invalid'] }

      it 'verifies signature and raises error' do
        expect { verify_callback.(params) }.to raise_error(VerifyCallback::Error)
      end
    end
  end
end
