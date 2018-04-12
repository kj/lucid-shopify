# frozen_string_literal: true

require 'lucid_shopify/container'

module LucidShopify
  class CreateWebhook
    #
    # @param client [#post_json]
    #
    def initialize(client: Container[:client])
      @client = client
    end

    #
    # @param request_credentials [RequestCredentials]
    # @param webhook [Hash]
    #
    def call(request_credentials, webhook)
      data = {**webhook, address: LucidShopify.config.webhook_uri}

      @client.post_json(request_credentials, 'webhooks', webhook: data)
    end
  end
end
