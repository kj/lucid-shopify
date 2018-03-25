# frozen_string_literal: true

require 'lucid_shopify/get_request'
require 'lucid_shopify/response'

RSpec.describe LucidShopify::Response do
  let(:request) { LucidShopify::GetRequest.new(credentials, 'example/path') }
  let(:status_code) { 200 }
  let(:headers) { {} }
  let(:data) { '{}' }
  let(:response) { LucidShopify::Response.new(request, status_code, headers, data) }

  it 'has attributes' do
    expect(response.request).to be_a(LucidShopify::Request)
    expect(response.status_code).to be(status_code)
    expect(response.headers).to be_a(Hash)
    expect(response.data).to be_a(String)
  end

  context 'with non-json content' do
    let(:headers) { {'Content-Type' => 'text/plain'} }
    let(:data) { '' }

    it 'has parsed response data (empty)' do
      expect(response.data_hash).to eq({})
    end
  end

  context 'with json content' do
    let(:headers) { {'Content-Type' => 'application/json'} }
    let(:data) { '{"example": "data"}' }

    it 'has parsed response data' do
      expect(response.data_hash).to include('example' => 'data')
    end
  end

  context 'with a client error status code' do
    let(:status_code) { rand(400..499) }

    it 'is unsuccessful' do
      expect(response.success?).to be(false)
      expect(response.failure?).to be(true)
    end

    it 'raises an error on assertion' do
      error_class = LucidShopify::Response::ClientError

      expect { response.assert! }.to raise_error do |e|
        expect(e).to be_a(error_class)
        expect(e.message).to eq("bad response (#{status_code})")
        expect(e.request).to be(request)
        expect(e.response).to be(response)
      end

      expect { response.data! }.to raise_error(error_class)
      expect { response.data_hash! }.to raise_error(error_class)
    end
  end

  context 'with a server error status code' do
    let(:status_code) { rand(500..599) }

    it 'is unsuccessful' do
      expect(response.success?).to be(false)
      expect(response.failure?).to be(true)
    end

    it 'raises an error on assertion' do
      error_class = LucidShopify::Response::ServerError

      expect { response.assert! }.to raise_error do |e|
        expect(e).to be_a(error_class)
        expect(e.message).to eq("bad response (#{status_code})")
        expect(e.request).to be(request)
        expect(e.response).to be(response)
      end

      expect { response.data! }.to raise_error(error_class)
      expect { response.data_hash! }.to raise_error(error_class)
    end
  end

  context 'with a success status code' do
    let(:status_code) { rand(200..299) }

    it 'is successful' do
      expect(response.success?).to be(true)
      expect(response.failure?).to be(false)
    end

    it 'assert! returns self' do
      expect(response.assert!).to be(response)
    end

    it 'asserts success and returns data' do
      expect(response.data!).to be(response.data)
    end

    it 'asserts success and returns parsed data' do
      expect(response.data_hash!).to be(response.data_hash)
    end
  end
end
