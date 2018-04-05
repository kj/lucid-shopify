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

    # @return [Hash<String, Array<#call>>]
    attr_reader :handlers

    #
    # Call each of the handlers registered for the given topic in turn. See
    # {#register} below for more on webhook handlers.
    #
    # @param webhook [Webhook]
    #
    def call(webhook)
      handlers[webhook.topic]&.each { |handler| handler.(webhook) }
    end

    #
    # Register a handler for a webhook topic. The callable handler will be
    # called with the argument passed to {#call}.
    #
    # @param topic [String] e.g. 'orders/create'
    # @param handler [#call]
    #
    def register(topic, handler)
      handlers[topic] ||= []
      handlers[topic] << handler
    end
  end
end
