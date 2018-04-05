# frozen_string_literal: true

require 'lucid_shopify/container'

module LucidShopify
  class DeleteWebhook
    extend Dry::Initializer

    # @return [#delete]
    option :client, default: proc { Container[:client] }

    #
    # @param request_credentials [RequestCredentials]
    # @param id [Integer]
    #
    def call(request_credentials, id)
      client.delete(request_credentials, "webhooks/#{id}")
    end
  end
end
