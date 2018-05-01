# frozen_string_literal: true

module LucidShopify
  class WebhookHandlerList
    def initialize
      @handlers = {}
    end

    #
    # Register a handler for a webhook topic. The callable handler should
    # receive a single {Webhook} argument.
    #
    # @param topic [String]
    # @param handler [#call]
    #
    def register(topic, handler = nil, &block)
      raise ArgumentError unless nil ^ handler ^ block

      handler = block if block

      @handlers[topic] ||= []
      @handlers[topic] << handler

      nil
    end

    #
    # @param topic [String]
    #
    def [](topic)
      @handlers[topic] || []
    end

    #
    # Call each of the handlers registered for the given topic in turn.
    #
    # @param webhook [Webhook]
    #
    def delegate(webhook)
      self[webhook.topic].each { |handler| handler.(webhook) }
    end
  end
end
