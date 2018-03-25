# frozen_string_literal: true

require 'lucid_shopify/put_request'

require_relative 'request_shared_examples'

RSpec.describe LucidShopify::PutRequest do
  let(:request) { LucidShopify::PutRequest.new(credentials, 'example/path', example: 'data') }

  include_examples 'request'

  it 'uses the PUT method' do
    expect(request.http_method).to be(:put)
  end

  it 'exposes json in options' do
    expect(request.options).to include(json: {example: 'data'})
  end
end
