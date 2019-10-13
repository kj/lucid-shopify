# frozen_string_literal: true

require_relative 'request_shared_examples'

module Lucid
  module Shopify
    RSpec.describe GetRequest do
      subject(:request) { GetRequest.new(credentials, path, example: 'param') }

      it_behaves_like 'request' do
        it { is_expected.to have_attributes(http_method: :get) }

        it 'exposes params in options' do
          expect(request.options).to include(params: {example: 'param'})
        end
      end
    end
  end
end
