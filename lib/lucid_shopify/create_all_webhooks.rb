# frozen_string_literal: true

require 'lucid_shopify/container'

module LucidShopify
  class CreateAllWebhooks
    # @param create_webhook [#call]
    def initialize(create_webhook: Container[:create_webhook])
      @create_webhook = create_webhook
    end

    # Create all webhooks for the shop. Shopify ignores any webhooks which
    # already exist remotely.
    #
    # @param credentials [Credentials]
    # @param webhooks [WebhookList]
    #
    # @return [Array<Hash>] response data
    def call(credentials, webhooks: Container[:webhook_list])
      webhooks.map do |webhook|
        Thread.new { @create_webhook.(credentials, webhook) }
      end.map(&:value)
    end
  end
end
