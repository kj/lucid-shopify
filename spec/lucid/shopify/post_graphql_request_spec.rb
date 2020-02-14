# frozen_string_literal: true

require_relative 'request_shared_examples'

module Lucid
  module Shopify
    RSpec.describe PostGraphQLRequest do
      subject(:request) { PostGraphQLRequest.new(credentials, '{}', {}) }

      it_behaves_like 'request' do
        let(:path) { 'graphql' }

        it { is_expected.to have_attributes(http_method: :post) }

        it 'exposes json in options' do
          expect(request.options).to include(json: {query: '{}', variables: {}})
        end
      end
    end
  end
end
