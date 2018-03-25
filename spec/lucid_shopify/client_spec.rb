# frozen_string_literal: true

require 'lucid_shopify/client'

RSpec.describe LucidShopify::Client do
  let(:send_request) { double }
  let(:client) do
    LucidShopify::Client.new(
      send_request: send_request
    )
  end

  it 'sends a delete request' do
    expect(send_request).to receive(:call).with(instance_of(LucidShopify::DeleteRequest))

    client.delete(credentials, 'example/path')
  end

  it 'sends a get request' do
    expect(send_request).to receive(:call).with(instance_of(LucidShopify::GetRequest))

    client.get(credentials, 'example/path', {})
  end

  it 'sends a post request' do
    expect(send_request).to receive(:call).with(instance_of(LucidShopify::PostRequest))

    client.post_json(credentials, 'example/path', example: 'data')
  end

  it 'sends a put request' do
    expect(send_request).to receive(:call).with(instance_of(LucidShopify::PutRequest))

    client.put_json(credentials, 'example/path', example: 'data')
  end
end
