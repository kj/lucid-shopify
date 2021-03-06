# frozen_string_literal: true

require 'lucid/shopify'

module Lucid
  module Shopify
    class GetRequest < Request
      # @private
      #
      # @param credentials [Credentials]
      # @param path [String] the endpoint relative to the base URL
      # @param params [Hash] the query params
      def initialize(credentials, path, params = {})
        super(credentials, :get, path, params: params)
      end
    end
  end
end
