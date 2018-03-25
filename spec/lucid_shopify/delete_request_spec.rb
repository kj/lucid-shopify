# frozen_string_literal: true

require 'lucid_shopify/delete_request'

require_relative 'request_shared_examples'

RSpec.describe LucidShopify::DeleteRequest do
  let(:request) { LucidShopify::DeleteRequest.new(credentials, 'example/path') }

  include_examples 'request'

  it 'uses the DELETE method' do
    expect(request.http_method).to be(:delete)
  end

  it 'exposes no options' do
    expect(request.options).to eq({})
  end
end
