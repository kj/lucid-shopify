# frozen_string_literal: true

require 'lucid_shopify/assert_callback'

module LucidShopify
  RSpec.describe AssertCallback do
    subject(:assert_callback) { AssertCallback.new }

    include_fixtures 'signed_callback.yml'

    context 'when signature is valid' do
      let(:params) { signed_callback['valid'] }

      it 'asserts signature' do
        expect { assert_callback.(params) }.not_to raise_error
      end
    end

    context 'when signature is invalid' do
      let(:params) { signed_callback['invalid'] }

      it 'asserts signature and raises error' do
        expect { assert_callback.(params) }.to raise_error(AssertCallback::Error)
      end
    end
  end
end
