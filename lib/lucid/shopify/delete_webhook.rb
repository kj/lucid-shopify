# frozen_string_literal: true

require 'lucid/shopify/container'

module Lucid
  module Shopify
    class DeleteWebhook
      # @param client [#delete]
      def initialize(client: Container[:client])
        @client = client
      end

      # @param credentials [Credentials]
      # @param id [Integer]
      #
      # @return [Hash] response data
      def call(credentials, id)
        @client.delete(credentials, "webhooks/#{id}")
      end
    end
  end
end
