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
    # @param credentials [Credentials]
    # @param webhook [Hash]
    #
    # @return [Hash] response data
    #
    def call(credentials, webhook)
      data = {**webhook, address: LucidShopify.config.webhook_uri}

      @client.post_json(credentials, 'webhooks', webhook: data)
    end
  end
end
