# frozen_string_literal: true

require 'lucid_shopify'

module LucidShopify
  class DeleteRequest < Request
    # @private
    #
    # @param credentials [Credentials]
    # @param path [String] the endpoint relative to the base URL
    def initialize(credentials, path)
      super(credentials, :delete, path)
    end
  end
end
