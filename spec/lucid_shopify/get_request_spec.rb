# frozen_string_literal: true

require 'lucid_shopify/get_request'

require_relative 'request_shared_examples'

RSpec.describe LucidShopify::GetRequest do
  let(:request) { LucidShopify::GetRequest.new(credentials, 'example/path', example: 'param') }

  include_examples 'request'

  it 'uses the GET method' do
    expect(request.http_method).to be(:get)
  end

  it 'exposes params in options' do
    expect(request.options).to include(params: {example: 'param'})
  end
end
