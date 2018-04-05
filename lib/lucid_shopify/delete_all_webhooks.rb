# frozen_string_literal: true

require 'lucid_shopify/container'

module LucidShopify
  class DeleteAllWebhooks
    extend Dry::Initializer

    # @return [#get]
    option :client, default: proc { Container[:client] }
    # @return [#call]
    option :delete_webhook, default: proc { Container[:delete_webhook] }

    #
    # Delete any existing webhooks.
    #
    # @param request_credentials [RequestCredentials]
    #
    def call(request_credentials)
      webhooks = client.get('webhooks')['webhooks']

      webhooks.map do |webhook|
        Thread.new { delete_webhook.(request_credentials, webhook['id']) }
      end.map(&:value)
    end
  end
end
