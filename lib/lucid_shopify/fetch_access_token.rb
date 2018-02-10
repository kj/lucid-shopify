# frozen_string_literal: true

require 'lucid_shopify/client'

module LucidShopify
  class FetchAccessToken
    Error = Class.new(StandardError)

    #
    # @param client [Client]
    # @param credentials [Credentials]
    #
    def initialize(client, credentials: LucidShopify.credentials)
      @client = client
      @credentials = credentials
    end

    # @return [Client]
    attr_reader :client
    # @return [Credentials]
    attr_reader :credentials

    #
    # Exchange an authorization code for a new Shopify access token.
    #
    # @param authorization_code [String]
    #
    # @return [String] the access token
    #
    # @raise [Error] if the response is invalid
    #
    def call(authorization_code)
      data = client.post_json('oauth/access_token', post_data(authorization_code))

      raise Error if data['access_token'].nil?
      raise Error if data['scope'] != credentials.scope

      data['access_token']
    end

    #
    # @param authorization_code [String]
    #
    # @return [Hash]
    #
    private def post_data(authorization_code)
      {
        client_id: credentials.api_key,
        client_secret: credentials.shared_secret,
        code: authorization_code,
      }
    end
  end
end
