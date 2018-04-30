# frozen_string_literal: true

require 'lucid_shopify'

module LucidShopify
  class PutRequest < Request
    #
    # @private
    #
    # @param credentials [RequestCredentials]
    # @param path [String] the endpoint relative to the base URL
    # @param json [Hash] the JSON request body
    #
    def initialize(credentials, path, json)
      super(credentials, :put, path, json: json)
    end
  end
end
