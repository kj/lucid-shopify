# frozen_string_literal: true

require 'lucid_shopify/delete_request'

require_relative 'request_shared_examples'

module LucidShopify
  RSpec.describe DeleteRequest do
    subject(:request) { DeleteRequest.new(credentials, 'example/path') }

    it_behaves_like 'request' do
      it { is_expected.to have_attributes(http_method: :delete) }

      it 'exposes no options' do
        expect(request.options).to eq({})
      end
    end
  end
end
