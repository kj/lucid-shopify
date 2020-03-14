# frozen_string_literal: true

require 'lucid/shopify/container'

module Lucid
  module Shopify
    class CreateWebhook
      # @param client [#post_json]
      def initialize(client: Container[:client])
        @client = client
      end

      # @param credentials [Credentials]
      # @param webhook [Hash]
      #
      # @return [Hash] response data
      def call(credentials, webhook)
        data = {**webhook, address: Shopify.config.webhook_uri}

        @client.post_json(credentials, 'webhooks', webhook: data)
      rescue Response::Error => e
        raise e unless e.response.error_message?([
          /has already been taken/,
        ])
      end
    end
  end
end
