# frozen_string_literal: true

require_relative 'request_shared_examples'

module Lucid
  module Shopify
    RSpec.describe PutRequest do
      subject(:request) { PutRequest.new(credentials, 'example/path', example: 'data') }

      it_behaves_like 'request' do
        it { is_expected.to have_attributes(http_method: :put) }

        it 'exposes json in options' do
          expect(request.options).to include(json: {example: 'data'})
        end
      end
    end
  end
end
