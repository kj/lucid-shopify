# frozen_string_literal: true

require 'lucid_shopify/container'

module LucidShopify
  class CreateWebhook
    extend Dry::Initializer

    # @return [#post_json]
    option :client, default: proc { Container[:client] }

    #
    # @param request_credentials [RequestCredentials]
    # @param webhook [Hash]
    #
    def call(request_credentials, webhook)
      data = {**webhook, address: LucidShopify.config.webhook_uri}

      client.post_json(request_credentials, 'webhooks', webhook: data)
    end
  end
end
