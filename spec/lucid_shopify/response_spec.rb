# frozen_string_literal: true

require 'lucid_shopify/get_request'
require 'lucid_shopify/response'

RSpec.describe LucidShopify::Response do
  let(:request) { LucidShopify::GetRequest.new(credentials, 'example/path') }
  let(:status_code) { 200 }
  let(:headers) { {} }
  let(:data) { '{}' }

  subject(:response) { LucidShopify::Response.new(request, status_code, headers, data) }

  it { is_expected.to have_attributes(request: request) }
  it { is_expected.to have_attributes(status_code: status_code) }
  it { is_expected.to have_attributes(headers: headers) }
  it { is_expected.to have_attributes(data: data) }

  context 'with non-json content' do
    let(:headers) { {'Content-Type' => 'text/plain'} }
    let(:data) { '' }

    it { is_expected.to have_attributes(data_hash: {}) }
  end

  context 'with json content' do
    let(:headers) { {'Content-Type' => 'application/json'} }
    let(:data) { '{"example": "data"}' }

    it { is_expected.to have_attributes(data_hash: {'example' => 'data'}) }
  end

  shared_examples 'status code' do |range, error_class|
    context "when status code is within #{range}" do
      let(:status_code) { rand(range) }

      it { is_expected.not_to satisfy('succeed', &:success?) }
      it { is_expected.to satisfy('fail', &:failure?) }

      it 'raises an error on #assert!' do
        expect { response.assert! }.to raise_error do |error|
          expect(error).to be_a(error_class)
          expect(error.message).to eq("bad response (#{status_code})")
          expect(error.request).to be(request)
          expect(error.response).to be(response)
        end
      end
    end
  end

  include_examples 'status code', 400..499, LucidShopify::Response::ClientError
  include_examples 'status code', 500..599, LucidShopify::Response::ServerError

  context 'with a success status code' do
    let(:status_code) { rand(200..299) }

    it { is_expected.to satisfy('succeed', &:success?) }
    it { is_expected.not_to satisfy('fail', &:failure?) }

    it 'assert! returns self' do
      expect(response.assert!).to be(response)
    end
  end
end
