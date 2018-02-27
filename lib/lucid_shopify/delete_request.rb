# frozen_string_literal: true

require 'lucid_shopify/request'

module LucidShopify
  class DeleteRequest < Request
    #
    # @param credentials [RequestCredentials]
    # @param path [String] the endpoint relative to the base URL
    #
    def initialize(credentials, path)
      super(credentials, :delete, path)
    end
  end
end
