# frozen_string_literal: true

require 'lucid_shopify/container'

module LucidShopify
  class Authorize
    Error = Class.new(Error)

    #
    # @param client [#post_json]
    #
    def initialize(client: Container[:client])
      @client = client
    end

    #
    # Exchange an authorization code for a new Shopify access token.
    #
    # @param myshopify_domain [String]
    # @param authorization_code [String]
    #
    # @return [String] the access token
    #
    # @raise [Error] if the response is invalid
    #
    def call(myshopify_domain, authorization_code)
      credentials = Credentials.new(myshopify_domain)

      data = @client.post_json(credentials, 'oauth/access_token', post_data(authorization_code))

      raise Error if data['access_token'].nil?
      raise Error if data['scope'] != LucidShopify.config.scope

      data['access_token']
    end

    #
    # @param authorization_code [String]
    #
    # @return [Hash]
    #
    private def post_data(authorization_code)
      {
        client_id: LucidShopify.config.api_key,
        client_secret: LucidShopify.config.shared_secret,
        code: authorization_code,
      }
    end
  end
end
