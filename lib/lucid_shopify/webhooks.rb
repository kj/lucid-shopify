# frozen_string_literal: true

require 'dry-initializer'

require 'lucid_shopify/client'
require 'lucid_shopify/credentials'

module LucidShopify
  class Webhooks
    extend Dry::Initializer

    # @return [Client]
    option :client, default: proc { Client.new }
    # @return [Credentials]
    option :credentials, default: proc { LucidShopify.credentials }

    #
    # Delete any existing webhooks, then (re)create all webhooks for the shop.
    #
    # @param request_credentials [RequestCredentials]
    #
    def create_all(request_credentials)
      delete_all

      LucidShopify.webhooks.map do |webhook|
        Thread.new { create(request_credentials, webhook) }
      end.map(&:value)
    end

    #
    # Create a webhook.
    #
    # @param request_credentials [RequestCredentials]
    # @param webhook [Hash]
    #
    def create(request_credentials, webhook)
      data = {}
      data[:address] = credentials.webhook_uri
      data[:fields] = webhook[:fields] if webhook[:fields]
      data[:topic] = webhook[:topic]

      client.post_json(request_credentials, 'webhooks', webhook: data)
    end

    #
    # Delete any existing webhooks.
    #
    # @param request_credentials [RequestCredentials]
    #
    def delete_all(request_credentials)
      webhooks = client.get('webhooks')['webhooks']

      webhooks.map do |webhook|
        Thread.new { delete(request_credentials, webhook['id']) }
      end.map(&:value)
    end

    #
    # Delete a webhook.
    #
    # @param request_credentials [RequestCredentials]
    # @param id [Integer]
    #
    def delete(request_credentials, id)
      client.delete(request_credentials, "webhooks/#{id}")
    end
  end
end

class << LucidShopify
  #
  # Webhooks created for each shop.
  #
  # @return [Array<Hash>]
  #
  # @example
  #   LucidShopify.webhooks << {topic: 'orders/create', fields: %w(id)}
  #
  def webhooks
    @webhooks ||= []
  end
end
