# frozen_string_literal: true

require 'lucid_shopify/post_request'

require_relative 'request_shared_examples'

RSpec.describe LucidShopify::PostRequest do
  let(:request) { LucidShopify::PostRequest.new(credentials, 'example/path', example: 'data') }

  include_examples 'request'

  it 'uses the POST method' do
    expect(request.http_method).to be(:post)
  end

  it 'exposes json in options' do
    expect(request.options).to include(json: {example: 'data'})
  end
end
