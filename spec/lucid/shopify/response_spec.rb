# frozen_string_literal: true

module Lucid
  module Shopify
    RSpec.describe Response do
      let(:request) { GetRequest.new(credentials, 'example/path') }
      let(:status_code) { 200 }
      let(:headers) { {} }
      let(:data) { '{}' }

      subject(:response) { Response.new(request, status_code, headers, data) }

      it { is_expected.to have_attributes(request: request) }
      it { is_expected.to have_attributes(status_code: status_code) }
      it { is_expected.to have_attributes(headers: headers) }
      it { is_expected.to have_attributes(data: data) }
      it { is_expected.to have_attributes(errors: {}) }
      it { is_expected.to have_attributes(errors?: false) }

      context 'with non-json content' do
        let(:headers) { {'Content-Type' => 'text/plain'} }
        let(:data) { '' }

        it { is_expected.to have_attributes(data_hash: {}) }
      end

      context 'with json content' do
        let(:headers) { {'Content-Type' => 'application/json'} }
        let(:data) { '{"example":"data"}' }

        it { is_expected.to have_attributes(data_hash: {'example' => 'data'}) }

        it 'is enumerable' do
          expect { |b| response.each(&b) }.to yield_with_args(
            ['example', 'data']
          )
        end

        it 'is like a hash' do
          expect(response['example']).to eq('data')
        end

        it 'serialises to JSON' do
          expect(response.to_json).to eq(data)
        end
      end

      shared_examples 'status code' do |range, error_class|
        context "when status code is within #{range}" do
          let(:status_code) { rand(range) }
          let(:headers) { {'Content-Type' => 'application/json'} }
          let(:data) { '{"errors":"example"}' }

          it { is_expected.not_to satisfy('succeed', &:success?) }
          it { is_expected.to satisfy('fail', &:failure?) }

          it 'raises an error on #assert!' do
            expect { response.assert! }.to raise_error do |error|
              expect(error).to be_a(error_class)
              expect(error.message).to eq("bad response (#{status_code}): example [resource]")
              expect(error.request).to be(request)
              expect(error.response).to be(response)
              expect(error.response).to have_attributes(data_hash: {'errors' => 'example'})
              expect(error.response).to have_attributes(errors: {'resource' => 'example'})
              expect(error.response).to have_attributes(error_messages: ['example [resource]'])
              expect(error.response.errors?).to be(true)
              expect(error.response.error_message?(['example [resource]'])).to be(true)
              expect(error.response.error_message?([/resource/])).to be(true)
              expect(error.response.error_message?([/example/])).to be(true)
              expect(error.response.error_message?(['example'])).to be(false)
              expect(error.response.error_message?(['not a message'])).to be(false)
            end
          end
        end
      end

      include_examples 'status code', 400..499, Response::ClientError
      include_examples 'status code', 500..599, Response::ServerError

      context 'with a success status code' do
        let(:status_code) { rand(200..299) }

        it { is_expected.to satisfy('succeed', &:success?) }
        it { is_expected.not_to satisfy('fail', &:failure?) }

        it 'assert! returns self' do
          expect(response.assert!).to be(response)
        end
      end

      context 'with graphql user errors' do
        let(:request) { GraphQLPostRequest.new(credentials, '{}') }
        let(:headers) { {'Content-Type' => 'application/json'} }
        let(:data) { '{"data":{"userErrors":[{"field":["path","to","example"],"message":"example"}]}}' }

        it { is_expected.to have_attributes(user_errors?: true) }
        it { is_expected.to have_attributes(user_errors: {'path.to.example' => 'example'}) }
      end

      context 'with graphql user errors (nil field)' do
        let(:request) { GraphQLPostRequest.new(credentials, '{}') }
        let(:headers) { {'Content-Type' => 'application/json'} }
        let(:data) { '{"data":{"userErrors":[{"field":null,"message":"example"}]}}' }

        it { is_expected.to have_attributes(user_errors?: true) }
        it { is_expected.to have_attributes(user_errors: {'.' => 'example'}) }
      end

      # TODO: #next
      # TODO: #previous
    end
  end
end
