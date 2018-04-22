# frozen_string_literal: true

require 'dry/container'

require 'lucid_shopify'

module LucidShopify
  Container = Dry::Container.new

  # Services only (dependencies); no value objects, entities.
  Container.register(:activate_charge) { ActivateCharge.new }
  Container.register(:assert_callback) { AssertCallback.new }
  Container.register(:assert_webhook) { AssertWebhook.new }
  Container.register(:client) { Client.new }
  Container.register(:create_all_webhooks) { CreateAllWebhooks.new }
  Container.register(:create_charge) { CreateCharge.new }
  Container.register(:create_webhook) { CreateWebhook.new }
  Container.register(:delete_all_webhooks) { DeleteAllWebhooks.new }
  Container.register(:delete_webhook) { DeleteWebhook.new }
  Container.register(:fetch_access_token) { FetchAccessToken.new }
  Container.register(:send_request) { SendRequest.new }
  Container.register(:send_throttled_request) { SendThrottledRequest.new }
end
