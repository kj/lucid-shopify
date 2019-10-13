# frozen_string_literal: true

require 'lucid/shopify'

module Lucid
  module Shopify
    class PostRequest < Request
      # @private
      #
      # @param credentials [Credentials]
      # @param path [String] the endpoint relative to the base URL
      # @param json [Hash] the JSON request body
      def initialize(credentials, path, json)
        super(credentials, :post, path, json: json)
      end
    end
  end
end
