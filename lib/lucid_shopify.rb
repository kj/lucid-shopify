# frozen_string_literal: true

require 'dry/initializer'

begin
  require 'redis'
rescue LoadError
end

module LucidShopify
  autoload :ActivateCharge, 'lucid_shopify/activate_charge'
  autoload :Authorise, 'lucid_shopify/authorise'
  autoload :Client, 'lucid_shopify/client'
  autoload :Container, 'lucid_shopify/container'
  autoload :CreateAllWebhooks, 'lucid_shopify/create_all_webhooks'
  autoload :CreateCharge, 'lucid_shopify/create_charge'
  autoload :CreateWebhook, 'lucid_shopify/create_webhook'
  autoload :Credentials, 'lucid_shopify/credentials'
  autoload :DeleteAllWebhooks, 'lucid_shopify/delete_all_webhooks'
  autoload :DeleteRequest, 'lucid_shopify/delete_request'
  autoload :DeleteWebhook, 'lucid_shopify/delete_webhook'
  autoload :Error, 'lucid_shopify/error'
  autoload :GetRequest, 'lucid_shopify/get_request'
  autoload :PostRequest, 'lucid_shopify/post_request'
  autoload :PutRequest, 'lucid_shopify/put_request'
  autoload :RedisThrottledStrategy, 'lucid_shopify/redis_throttled_strategy'
  autoload :Request, 'lucid_shopify/request'
  autoload :Response, 'lucid_shopify/response'
  autoload :Result, 'lucid_shopify/result'
  autoload :SendRequest, 'lucid_shopify/send_request'
  autoload :ThrottledStrategy, 'lucid_shopify/throttled_strategy'
  autoload :VerifyCallback, 'lucid_shopify/verify_callback'
  autoload :VerifyWebhook, 'lucid_shopify/verify_webhook'
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

require 'lucid_shopify/config'
