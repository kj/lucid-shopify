# frozen_string_literal: true

require 'lucid_shopify/client'

module LucidShopify
  #
  # An interface to the Shopify API, authorized for a given shop.
  #
  class AuthorizedClient < Client
    #
    # @param shop_credentials [ShopCredentials]
    #
    def initialize(shop_credentials)
      @shop_credentials = shop_credentials
    end

    # @return [ShopCredentials]
    attr_reader :shop_credentials

    #
    # @return [ThrottledClient]
    #
    def throttled
      @throttled_client ||= ThrottledClient.new(shop_credentials)
    end

    #
    # @return [AuthorizedClient]
    #
    def unthrottled
      self
    end

    private def client
      HTTP.headers(
        'Accept' => 'application/json',
        'X-Shopify-Access-Token' => shop_credentials.access_token
      )
    end

    private def myshopify_domain
      shop_credentials.myshopify_domain
    end
  end
end

require 'lucid_shopify/throttled_client'
