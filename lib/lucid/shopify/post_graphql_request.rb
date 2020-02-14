# frozen_string_literal: true

require 'lucid/shopify'

module Lucid
  module Shopify
    class PostGraphQLRequest < Request
      # @private
      #
      # @param credentials [Credentials]
      # @param query [String] the GraphQL query
      # @param variables [Hash] the GraphQL variables (if any)
      def initialize(credentials, query, variables: {})
        super(credentials, :post, 'graphql', json: {
          query: query,
          variables: variables,
        })
      end
    end
  end
end
