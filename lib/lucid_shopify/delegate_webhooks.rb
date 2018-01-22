# frozen_string_literal: true

module LucidShopify
  class DelegateWebhooks
    class << self
      #
      # @return [DelegateWebhooks]
      #
      def default
        @default ||= new
      end
    end

    def initialize
      @handlers = {}
    end

    # @return [Hash<String, Array<Class, #call>>]
    attr_reader :handlers

    #
    # Call each of the handlers registered for the given topic in turn. See
    # {#register} below for more on webhook handlers.
    #
    # @param myshopify_domain [String]
    # @param topic [String]
    # @param data [String] the raw JSON request data
    #
    def call(*args)
      _, topic, _ = *args

      handlers[topic]&.each do |handler|
        handler.is_a?(Class) ? handler.new(*args).() : handler.(*args)
      end
    end

    #
    # Register a handler for a webhook topic.
    #
    # If the handler is a callable, it will be called with the webhook arguments
    # passed to {#call}. If the handler is a class, the arguments will be passed
    # to `#new`, and `#call` will be called on the new instance, with no
    # arguments.
    #
    # @param topic [String] e.g. 'orders/create'
    # @param handler [Class, #call] e.g. `OrdersCreateWebhook`
    #
    def register(topic, handler)
      handlers[topic] ||= []
      handlers[topic] << handler
    end
  end
end
