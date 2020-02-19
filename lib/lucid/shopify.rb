# frozen_string_literal: true

require 'dry/initializer'
require 'dry/struct'

begin
  require 'redis'
rescue LoadError
end

module Lucid
  module Shopify
    autoload :ActivateCharge, 'lucid/shopify/activate_charge'
    autoload :Authorise, 'lucid/shopify/authorise'
    autoload :BulkRequest, 'lucid/shopify/bulk_request'
    autoload :Client, 'lucid/shopify/client'
    autoload :Container, 'lucid/shopify/container'
    autoload :CreateAllWebhooks, 'lucid/shopify/create_all_webhooks'
    autoload :CreateCharge, 'lucid/shopify/create_charge'
    autoload :CreateWebhook, 'lucid/shopify/create_webhook'
    autoload :Credentials, 'lucid/shopify/credentials'
    autoload :DeleteAllWebhooks, 'lucid/shopify/delete_all_webhooks'
    autoload :DeleteRequest, 'lucid/shopify/delete_request'
    autoload :DeleteWebhook, 'lucid/shopify/delete_webhook'
    autoload :Error, 'lucid/shopify/error'
    autoload :GetRequest, 'lucid/shopify/get_request'
    autoload :GraphQLPostRequest, 'lucid/shopify/graphql_post_request'
    autoload :ParseLinkHeader, 'lucid/shopify/parse_link_header'
    autoload :PostRequest, 'lucid/shopify/post_request'
    autoload :PutRequest, 'lucid/shopify/put_request'
    autoload :RedisThrottledStrategy, 'lucid/shopify/redis_throttled_strategy'
    autoload :Request, 'lucid/shopify/request'
    autoload :Response, 'lucid/shopify/response'
    autoload :Result, 'lucid/shopify/result'
    autoload :SendRequest, 'lucid/shopify/send_request'
    autoload :ThrottledStrategy, 'lucid/shopify/throttled_strategy'
    autoload :Types, 'lucid/shopify/types'
    autoload :VerifyCallback, 'lucid/shopify/verify_callback'
    autoload :VerifyWebhook, 'lucid/shopify/verify_webhook'
    autoload :VERSION, 'lucid/shopify/version'
    autoload :Webhook, 'lucid/shopify/webhook'
    autoload :WebhookHandlerList, 'lucid/shopify/webhook_handler_list'
    autoload :WebhookList, 'lucid/shopify/webhook_list'

    extend Dry::Configurable

    setting :api_key
    setting :api_version, '2020-01'
    setting :billing_callback_uri
    setting :callback_uri
    setting :logger, Logger.new(File::NULL).freeze
    setting :scope
    setting :shared_secret
    setting :webhook_uri

    class << self
      # @param version [String]
      #
      # @raise [RuntimeError]
      def assert_api_version!(version)
        raise "requires API version >= #{version}" if config.api_version < version
      end

      # Webhooks created for each shop.
      #
      # @return [WebhookList]
      #
      # @example
      #   Lucid::Shopify.webhooks.register('orders/create', fields: 'id,tags')
      def webhooks
        @webhooks ||= WebhookList.new
      end

      # Handlers for webhook topics.
      #
      # @return [WebhookHandlerList]
      #
      # @example
      #   Lucid::Shopify.handlers.register('orders/create', OrdersCreateWebhook.new)
      #
      # @example Call topic handlers
      #   webhook = Webhook.new(myshopify_domain, topic, data)
      #
      #   Lucid::Shopify.handlers.delegate(webhook)
      def handlers
        @handlers ||= WebhookHandlerList.new
      end
    end
  end
end
