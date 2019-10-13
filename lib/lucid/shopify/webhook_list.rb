# frozen_string_literal: true

module Lucid
  module Shopify
    class WebhookList
      include Enumerable

      def initialize
        @webhooks = []
      end

      # @yield [Hash]
      def each(&block)
        @webhooks.each(&block)
      end

      # @param topic [String]
      # @param fields [String] e.g. 'id,tags'
      def register(topic, fields: nil)
        @webhooks << {}.tap do |webhook|
          webhook[:topic] = topic
          webhook[:fields] = fields if fields
        end

        nil
      end
    end
  end
end
