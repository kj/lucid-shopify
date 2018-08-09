# frozen_string_literal: true

require 'lucid_shopify/container'

module LucidShopify
  class DeleteWebhook
    #
    # @param client [#delete]
    #
    def initialize(client: Container[:client])
      @client = client
    end

    #
    # @param request_credentials [RequestCredentials]
    # @param id [Integer]
    #
    # @return [Hash] response data
    #
    def call(request_credentials, id)
      @client.delete(request_credentials, "webhooks/#{id}")
    end
  end
end
