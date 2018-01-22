# frozen_string_literal: true

require 'lucid_shopify/client'

module LucidShopify
  class ExchangeAuthorizationCode
    Error = Class.new(StandardError)

    #
    # @param myshopify_domain [String]
    # @param credentials [Credentials]
    #
    def initialize(myshopify_domain, credentials: LucidShopify.credentials)
      @credentials = credentials
      @myshopify_domain = myshopify_domain
    end

    # @return [Credentials]
    attr_reader :credentials
    # @return [String]
    attr_reader :myshopify_domain

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

    private def client
      @client ||= Client.new(myshopify_domain)
    end

    private def post_data(authorization_code)
      {
        client_id: credentials.api_key,
        client_secret: credentials.shared_secret,
        code: authorization_code
      }
    end
  end
end
