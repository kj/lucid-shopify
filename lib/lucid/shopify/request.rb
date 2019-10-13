# frozen_string_literal: true

require 'lucid/shopify'

module Lucid
  module Shopify
    # @abstract
    class Request
      extend Dry::Initializer

      # @return [Credentials]
      param :credentials
      # @return [Symbol]
      param :http_method
      # @return [String] the endpoint relative to the base URL
      param :path, reader: :private
      # @return [Hash]
      param :options, default: -> { {} }

      # @return [Hash]
      param :http_headers, default: -> { build_headers }
      # @return [String]
      param :url, default: -> { build_url }

      # @return [String]
      private def build_url
        unless path.match?(/oauth/)
          admin_url = "https://#{credentials.myshopify_domain}/admin/api/#{api_version}"
        else
          admin_url = "https://#{credentials.myshopify_domain}/admin"
        end

        normalised_path = path.sub(/^\//, '')
        normalised_path = path.sub(/\.json$/, '')

        admin_url + '/' + normalised_path + '.json'
      end

      # @return [Hash]
      private def build_headers
        access_token = credentials.access_token

        {}.tap do |headers|
          headers['Accept'] = 'application/json'
          headers['X-Shopify-Access-Token'] = access_token if access_token
        end
      end

      # @return [String]
      private def api_version
        ENV.fetch('SHOPIFY_API_VERSION', Shopify.config.api_version)
      end
    end
  end
end
