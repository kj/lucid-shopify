# frozen_string_literal: true

require 'lucid_shopify/container'

module LucidShopify
  class CreateAllWebhooks
    #
    # @param create_webhook [#call]
    #
    def initialize(create_webhook: Container[:create_webhook])
      @create_webhook = create_webhook
    end

    #
    # Create all webhooks for the shop. Shopify ignores any webhooks which
    # already exist remotely.
    #
    # @param request_credentials [RequestCredentials]
    #
    def call(request_credentials)
      LucidShopify.webhooks.map do |webhook|
        Thread.new { @create_webhook.(request_credentials, webhook) }
      end.map(&:value)
    end
  end

  class << self
    #
    # Webhooks created for each shop.
    #
    # @return [Array<Hash>]
    #
    # @example
    #   LucidShopify.webhooks << {topic: 'orders/create', fields: 'id,line_items'}
    #
    def webhooks
      @webhooks ||= []
    end
  end
end
