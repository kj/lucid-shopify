# frozen_string_literal: true

require 'lucid/shopify/container'

module Lucid
  module Shopify
    class DeleteAllWebhooks
      # @param client [#get]
      # @param delete_webhook [#call]
      def initialize(client: Container[:client],
                     delete_webhook: Container[:delete_webhook])
        @client = client
        @delete_webhook = delete_webhook
      end

      # Delete any existing webhooks.
      #
      # @param credentials [Credentials]
      #
      # @return [Array<Hash>] response data
      def call(credentials)
        webhooks = @client.get(credentials, 'webhooks')['webhooks']

        webhooks.map do |webhook|
          Thread.new { @delete_webhook.(credentials, webhook['id']) }
        end.map(&:value)
      end
    end
  end
end
