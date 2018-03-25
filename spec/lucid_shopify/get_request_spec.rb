# frozen_string_literal: true

require 'lucid_shopify/get_request'

require_relative 'request_shared_examples'

RSpec.describe LucidShopify::GetRequest do
  subject(:request) { LucidShopify::GetRequest.new(credentials, path, example: 'param') }

  include_examples 'request'

  it { is_expected.to have_attributes(http_method: :get) }

  it 'exposes params in options' do
    expect(request.options).to include(params: {example: 'param'})
  end
end
