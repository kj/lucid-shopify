# frozen_string_literal: true

require 'dry-initializer'

require 'lucid_shopify/client'

module LucidShopify
  class FetchAccessToken
    Error = Class.new(StandardError)

    extend Dry::Initializer

    # @return [Client]
    option :client, default: proc { Client.new }
    # @return [Config]
    option :config, default: proc { LucidShopify.config }

    #
    # Exchange an authorization code for a new Shopify access token.
    #
    # @param request_credentials [RequestCredentials]
    # @param authorization_code [String]
    #
    # @return [String] the access token
    #
    # @raise [Error] if the response is invalid
    #
    def call(request_credentials, authorization_code)
      data = client.post_json(request_credentials, 'oauth/access_token', post_data(authorization_code))

      raise Error if data['access_token'].nil?
      raise Error if data['scope'] != config.scope

      data['access_token']
    end

    #
    # @param authorization_code [String]
    #
    # @return [Hash]
    #
    private def post_data(authorization_code)
      {
        client_id: config.api_key,
        client_secret: config.shared_secret,
        code: authorization_code,
      }
    end
  end
end
