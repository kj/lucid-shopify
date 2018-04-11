# frozen_string_literal: true

require 'lucid_shopify/container'

module LucidShopify
  class CreateWebhook
    #
    # @param [#post_json] client
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
