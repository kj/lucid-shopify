# frozen_string_literal: true

require 'dry/initializer'

module LucidShopify
  autoload :ActivateCharge, 'lucid_shopify/activate_charge'
  autoload :AssertCallback, 'lucid_shopify/assert_callback'
  autoload :AssertWebhook, 'lucid_shopify/assert_webhook'
  autoload :Charge, 'lucid_shopify/charge'
  autoload :Client, 'lucid_shopify/client'
  autoload :Config, 'lucid_shopify/config'
  autoload :Container, 'lucid_shopify/container'
  autoload :CreateAllWebhooks, 'lucid_shopify/create_all_webhooks'
  autoload :CreateCharge, 'lucid_shopify/create_charge'
  autoload :CreateWebhook, 'lucid_shopify/create_webhook'
  autoload :DeleteAllWebhooks, 'lucid_shopify/delete_all_webhooks'
  autoload :DeleteRequest, 'lucid_shopify/delete_request'
  autoload :DeleteWebhook, 'lucid_shopify/delete_webhook'
  autoload :Error, 'lucid_shopify/error'
  autoload :FetchAccessToken, 'lucid_shopify/fetch_access_token'
  autoload :GetRequest, 'lucid_shopify/get_request'
  autoload :PostRequest, 'lucid_shopify/post_request'
  autoload :PutRequest, 'lucid_shopify/put_request'
  autoload :RequestCredentials, 'lucid_shopify/request_credentials'
  autoload :Request, 'lucid_shopify/request'
  autoload :Response, 'lucid_shopify/response'
  autoload :Result, 'lucid_shopify/result'
  autoload :SendRequest, 'lucid_shopify/send_request'
  autoload :SendThrottledRequest, 'lucid_shopify/send_throttled_request'
  autoload :VERSION, 'lucid_shopify/version'
  autoload :Webhook, 'lucid_shopify/webhook'
  autoload :WebhookHandlerList, 'lucid_shopify/webhook_handler_list'
  autoload :WebhookList, 'lucid_shopify/webhook_list'

  class << self
    #
    # Webhooks created for each shop.
    #
    # @return [WebhookList]
    #
    # @example
    #   LucidShopify.webhooks.register('orders/create', fields: 'id,tags')
    #
    def webhooks
      @webhooks ||= WebhookList.new
    end

    #
    # Handlers for webhook topics.
    #
    # @return [WebhookHandlerList]
    #
    # @example
    #   LucidShopify.handlers.register('orders/create', OrdersCreateWebhook.new)
    #
    # @example Call topic handlers
    #   webhook = Webhook.new(myshopify_domain, topic, data)
    #
    #   LucidShopify.handlers.delegate(webhook)
    #
    def handlers
      @handlers ||= WebhookHandlerList.new
    end
  end
end
