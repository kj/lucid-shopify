# frozen_string_literal: true

require 'lucid_shopify'

module LucidShopify
  class GetRequest < Request
    #
    # @param credentials [RequestCredentials]
    # @param path [String] the endpoint relative to the base URL
    # @param params [Hash] the query params
    #
    def initialize(credentials, path, params = {})
      super(credentials, :get, path, params: params)
    end
  end
end
