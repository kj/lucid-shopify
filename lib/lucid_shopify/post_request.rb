# frozen_string_literal: true

require 'lucid_shopify'

module LucidShopify
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
