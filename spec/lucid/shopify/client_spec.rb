# frozen_string_literal: true

module Lucid
  module Shopify
    RSpec.describe Client do
      let(:send_request) { instance_double('SendRequest') }
      let(:send_throttled_request) { instance_double('SendThrottledRequest') }

      subject(:client) do
        Client.new(
          send_request: send_request,
          send_throttled_request: send_throttled_request
        )
      end

      it '#throttled enables request throttling' do
        expect(client.throttled).to be_throttled
      end

      it '#unthrottled disables request throttling' do
        expect(client.unthrottled).not_to be_throttled
      end

      it 'sends a delete request' do
        expect(send_request).to receive(:call).with(instance_of(DeleteRequest))

        client.delete(credentials, 'example/path')
      end

      it 'sends a get request' do
        expect(send_request).to receive(:call).with(instance_of(GetRequest))

        client.get(credentials, 'example/path', {})
      end

      it 'sends a post request' do
        expect(send_request).to receive(:call).with(instance_of(PostRequest))

        client.post_json(credentials, 'example/path', example: 'data')
      end

      it 'sends a put request' do
        expect(send_request).to receive(:call).with(instance_of(PutRequest))

        client.put_json(credentials, 'example/path', example: 'data')
      end
    end
  end
end
