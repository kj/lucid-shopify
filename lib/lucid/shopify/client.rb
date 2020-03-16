# frozen_string_literal: true

require 'lucid/shopify/container'

%w[delete get post graphql_post put].each { |m| require "lucid/shopify/#{m}_request" }

module Lucid
  module Shopify
    class Client
      # @param bulk_request [#call]
      # @param send_request [#call]
      # @param send_throttled_request [#call]
      # @param throttling [Boolean]
      def initialize(bulk_request: Container[:bulk_request],
                     send_request: Container[:send_request],
                     send_throttled_request: Container[:send_throttled_request],
                     throttling: true)
        @bulk_request = bulk_request
        @send_request = send_request
        @send_throttled_request = send_throttled_request
        @throttling = throttling

        @params = {
          bulk_request: @bulk_request,
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

      # @param credentials [Credentials]
      #
      # @return [AuthenticatedClient]
      def authenticate(credentials)
        AuthenticatedClient.new(self, credentials)
      end

      # If called with a block, calls {BulkRequest::Operation#call} immediately,
      # else, returns the {BulkRequest::Operation}.
      #
      # @see BulkRequest#call
      # @see BulkRequest::Operation#call
      def bulk(*args, &block)
        op = @bulk_request.(self, *args)

        block ? op.(&block) : op
      end

      # @see DeleteRequest#initialize
      def delete(*args)
        send_request.(DeleteRequest.new(*args))
      end

      # @see GetRequest#initialize
      def get(*args)
        send_request.(GetRequest.new(*args))
      end

      # @see GraphQLPostRequest#initialize
      def post_graphql(*args)
        send_request.(GraphQLPostRequest.new(*args))
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

    class AuthenticatedClient
      # @private
      #
      # @param client [Client]
      # @param credentials [Credentials]
      def initialize(client, credentials)
        @client = client
        @credentials = credentials
      end

      %i[delete get post_json put_json].each do |method|
        define_method(method) do |*args|
          @client.__send__(method, @credentials, *args)
        end
      end
    end
  end
end
