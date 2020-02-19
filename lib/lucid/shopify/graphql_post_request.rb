# frozen_string_literal: true

require 'lucid/shopify'

module Lucid
  module Shopify
    class GraphQLPostRequest < Request
      # @private
      #
      # @param credentials [Credentials]
      # @param query [String] the GraphQL query
      # @param variables [Hash] the GraphQL variables (if any)
      #
      # @see https://graphql.org/graphql-js/graphql-clients
      # @see https://graphql.org/graphql-js/mutations-and-input-types
      def initialize(credentials, query, variables: {})
        super(credentials, :post, 'graphql', json: {
          query: query,
          variables: variables,
        })
      end
    end
  end
end
