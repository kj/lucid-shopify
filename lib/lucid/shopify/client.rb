# frozen_string_literal: true

require 'lucid/shopify/container'

%w[delete get post put].each { |m| require "lucid/shopify/#{m}_request" }

module Lucid
  module Shopify
    class Client
      # @param send_request [#call]
      # @param send_throttled_request [#call]
      def initialize(send_request: Container[:send_request],
                     send_throttled_request: Container[:send_throttled_request],
                     throttling: false)
        @send_request = send_request
        @send_throttled_request = send_throttled_request
        @throttling = throttling

        @params = {
          send_request: @send_request,
          send_throttled_request: @send_throttled_request
        }
      end

      # @return [#call]
      private def send_request
        throttled? ? @send_throttled_request : @send_request
      end

      # @return [Boolean]
      def throttled?
        @throttling
      end

      # Returns a new instance with throttling enabled, or self.
      #
      # @return [Client, self]
      def throttled
        return self if throttled?

        self.class.new(**@params, throttling: true)
      end

      # Returns a new instance with throttling disabled, or self.
      #
      # @return [Client, self]
      def unthrottled
        return self unless throttled?

        self.class.new(**@params, throttling: false)
      end

      # @see DeleteRequest#initialize
      def delete(*args)
        send_request.(DeleteRequest.new(*args))
      end

      # @see GetRequest#initialize
      def get(*args)
        send_request.(GetRequest.new(*args))
      end

      # @see PostRequest#initialize
      def post_json(*args)
        send_request.(PostRequest.new(*args))
      end

      # @see PutRequest#initialize
      def put_json(*args)
        send_request.(PutRequest.new(*args))
      end
    end
  end
end
