# frozen_string_literal: true

require 'lucid_shopify/send_request'

%w(delete get post put).each do |method|
  require "lucid_shopify/#{method}_request"
end

RSpec.describe LucidShopify::SendRequest do
  subject(:send_request) { LucidShopify::SendRequest.new }

  shared_examples 'request' do |content_type, data, expected_data|
    let(:http_response) { double('http_response', code: status_code, headers: {'Content-Type' => content_type}, to_s: data) }

    before do
      allow(send_request).to receive(:send).and_return(http_response)
    end

    context 'responding 200' do
      let(:status_code) { 200 }

      it 'returns expected data' do
        expect(send_request.(request)).to eq(expected_data)
      end
    end

    context 'responding 400' do
      let(:status_code) { 400 }

      it 'raises a client error' do
        expect { send_request.(request) }.to raise_error(LucidShopify::Response::ClientError)
      end
    end

    context 'responding 500' do
      let(:status_code) { 500 }

      it 'raises a server error' do
        expect { send_request.(request) }.to raise_error(LucidShopify::Response::ServerError)
      end
    end
  end

  shared_examples 'request method' do
    context 'responding with application/json' do
      include_examples 'request', 'application/json', '{"id": 1}', {'id' => 1}
    end

    context 'responding with text/plain' do
      include_examples 'request', 'text/plain', '{"id": 1}', {}
    end
  end

  context 'with a DeleteRequest' do
    let(:request) { LucidShopify::DeleteRequest.new(credentials, '/') }

    include_examples 'request method'
  end

  context 'with a GetRequest' do
    let(:request) { LucidShopify::GetRequest.new(credentials, '/') }

    include_examples 'request method'
  end

  context 'with a PostRequest' do
    let(:request) { LucidShopify::PostRequest.new(credentials, '/', {}) }

    include_examples 'request method'
  end

  context 'with a PutRequest' do
    let(:request) { LucidShopify::PutRequest.new(credentials, '/', {}) }

    include_examples 'request method'
  end
end
