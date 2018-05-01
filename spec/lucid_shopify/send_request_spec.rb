# frozen_string_literal: true

require 'lucid_shopify/send_request'

%w[delete get post put].each { |m| require "lucid_shopify/#{m}_request" }

module LucidShopify
  RSpec.describe SendRequest do
    subject(:send_request) { SendRequest.new }

    shared_examples 'request' do |content_type, data, expected_data|
      let(:http_response) { instance_double('HTTP::Response') }

      before do
        allow(http_response).to receive(:code) { status_code }
        allow(http_response).to receive(:headers) do
          {
            'Content-Type' => content_type,
          }
        end
        allow(http_response).to receive(:to_s) { data }
        allow(send_request).to receive(:send).and_return(http_response)
      end

      context 'responding 200' do
        let(:status_code) { 200 }

        it 'returns expected data' do
          expect(send_request.(request)).to eq(expected_data)
        end
      end

      shared_examples 'error' do |type, error_class|
        it "raises a #{type} error" do
          expect { send_request.(request) }.to raise_error(error_class)
        end
      end

      context 'responding 400' do
        let(:status_code) { 400 }

        include_examples 'error', 'client', Response::ClientError
      end

      context 'responding 500' do
        let(:status_code) { 500 }

        include_examples 'error', 'server', Response::ServerError
      end
    end

    shared_examples 'request method' do
      context 'responding with application/json' do
        it_behaves_like 'request', 'application/json', '{"id": 1}', 'id' => 1
      end

      context 'responding with text/plain' do
        it_behaves_like 'request', 'text/plain', '{"id": 1}', {}
      end
    end

    context 'with a DeleteRequest' do
      let(:request) { DeleteRequest.new(credentials, '/') }

      it_behaves_like 'request method'
    end

    context 'with a GetRequest' do
      let(:request) { GetRequest.new(credentials, '/') }

      it_behaves_like 'request method'
    end

    context 'with a PostRequest' do
      let(:request) { PostRequest.new(credentials, '/', {}) }

      it_behaves_like 'request method'
    end

    context 'with a PutRequest' do
      let(:request) { PutRequest.new(credentials, '/', {}) }

      it_behaves_like 'request method'
    end
  end
end
