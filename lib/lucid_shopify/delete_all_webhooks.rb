# frozen_string_literal: true

require 'lucid_shopify/container'

module LucidShopify
  class DeleteAllWebhooks
    #
    # @param [#get] client
    # @param [#call] delete_webhook
    #
    def initialize(client: Container[:client],
                   delete_webhook: Container[:delete_webhook])
      @client = client
      @delete_webhook = delete_webhook
    end

    #
    # Delete any existing webhooks.
    #
    # @param request_credentials [RequestCredentials]
    #
    def call(request_credentials)
      webhooks = @client.get('webhooks')['webhooks']

      webhooks.map do |webhook|
        Thread.new { @delete_webhook.(request_credentials, webhook['id']) }
      end.map(&:value)
    end
  end
end
