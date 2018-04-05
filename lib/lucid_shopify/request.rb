# frozen_string_literal: true

require 'lucid_shopify'

module LucidShopify
  #
  # @abstract
  #
  class Request
    extend Dry::Initializer

    # @return [RequestCredentials]
    param :credentials
    # @return [Symbol]
    param :http_method
    # @return [String] the endpoint relative to the base URL
    param :path, reader: :private
    # @return [Hash]
    param :options, default: proc { {} }

    # @return [Hash]
    param :http_headers, default: proc { build_headers }
    # @return [String]
    param :url, default: proc { build_url }

    #
    # @return [String]
    #
    private def build_url
      admin_url = "https://#{credentials.myshopify_domain}/admin"

      normalized_path = path.sub(/^\//, '')
      normalized_path = path.sub(/\.json$/, '')

      admin_url + '/' + normalized_path + '.json'
    end

    #
    # @return [Hash]
    #
    private def build_headers
      access_token = credentials.access_token

      {}.tap do |headers|
        headers['Accept'] = 'application/json'
        headers['X-Shopify-Access-Token'] = access_token if access_token
      end
    end
  end
end
