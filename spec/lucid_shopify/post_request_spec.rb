# frozen_string_literal: true

require 'lucid_shopify/post_request'

require_relative 'request_shared_examples'

module LucidShopify
  RSpec.describe PostRequest do
    subject(:request) { PostRequest.new(credentials, 'example/path', example: 'data') }

    include_examples 'request'

    it { is_expected.to have_attributes(http_method: :post) }

    it 'exposes json in options' do
      expect(request.options).to include(json: {example: 'data'})
    end
  end
end
