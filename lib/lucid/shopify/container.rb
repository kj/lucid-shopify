# frozen_string_literal: true

require 'dry/container'
require 'http'

require 'lucid/shopify'

module Lucid
  module Shopify
    Container = Dry::Container.new

    # Services only (dependencies); no value objects, entities.
    Container.register(:activate_charge) { ActivateCharge.new }
    Container.register(:authorise) { Authorise.new }
    Container.register(:client) { Client.new }
    Container.register(:create_all_webhooks) { CreateAllWebhooks.new }
    Container.register(:create_charge) { CreateCharge.new }
    Container.register(:create_webhook) { CreateWebhook.new }
    Container.register(:delete_all_webhooks) { DeleteAllWebhooks.new }
    Container.register(:delete_webhook) { DeleteWebhook.new }
    Container.register(:http) { ::HTTP::Client.new }
    Container.register(:parse_link_header) { ParseLinkHeader.new }
    Container.register(:send_request) { SendRequest.new }
    Container.register(:send_throttled_request) do
      if defined?(Redis)
        SendRequest.new(strategy: RedisThrottledStrategy.new)
      else
        SendRequest.new(strategy: ThrottledStrategy.new)
      end
    end
    Container.register(:verify_callback) { VerifyCallback.new }
    Container.register(:verify_webhook) { VerifyWebhook.new }
    Container.register(:webhook_handler_list) { Shopify.handlers }
    Container.register(:webhook_list) { Shopify.webhooks }
  end
end
