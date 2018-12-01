# frozen_string_literal: true

require 'dry/container'
require 'http'

require 'lucid_shopify'
require 'lucid_shopify/config'

module LucidShopify
  Container = Dry::Container.new

  # Services only (dependencies); no value objects, entities.
  Container.register(:activate_charge) { ActivateCharge.new }
  Container.register(:authorize) { Authorize.new }
  Container.register(:client) { Client.new }
  Container.register(:create_all_webhooks) { CreateAllWebhooks.new }
  Container.register(:create_charge) { CreateCharge.new }
  Container.register(:create_webhook) { CreateWebhook.new }
  Container.register(:delete_all_webhooks) { DeleteAllWebhooks.new }
  Container.register(:delete_webhook) { DeleteWebhook.new }
  Container.register(:http) { ::HTTP::Client.new }
  Container.register(:send_request) { SendRequest.new }
  Container.register(:send_throttled_request) { SendRequest.new(strategy: ThrottledStrategy.new) }
  Container.register(:verify_callback) { VerifyCallback.new }
  Container.register(:verify_webhook) { VerifyWebhook.new }
  Container.register(:webhook_handler_list) { LucidShopify.handlers }
  Container.register(:webhook_list) { LucidShopify.webhooks }
end
