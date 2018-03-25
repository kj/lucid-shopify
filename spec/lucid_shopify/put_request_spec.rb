# frozen_string_literal: true

require 'lucid_shopify/put_request'

require_relative 'request_shared_examples'

RSpec.describe LucidShopify::PutRequest do
  subject(:request) { LucidShopify::PutRequest.new(credentials, 'example/path', example: 'data') }

  include_examples 'request'

  it { is_expected.to have_attributes(http_method: :put) }

  it 'exposes json in options' do
    expect(request.options).to include(json: {example: 'data'})
  end
end
