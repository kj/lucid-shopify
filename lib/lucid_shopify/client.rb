# frozen_string_literal: true

require 'json'
require 'http'

module LucidShopify
  #
  # An interface to the Shopify API for a given myshopify domain, without an
  # authorization header.
  #
  class Client
    class RequestError < StandardError
      #
      # @param method [String, Symbol]
      # @param url [String]
      # @param options [Hash]
      # @param response [HTTP::Response]
      #
      def initialize(method, url, options, response)
        @request = {
          method: method.to_s.upcase,
          url: url,
          options: options
        }

        @response = {
          status_code: response.code,
          errors: parse_errors(response.to_s)
        }
      end

      # @return [Hash]
      attr_reader :request
      # @return [HTTP::Response]
      attr_reader :response

      private def parse_errors(response_body)
        JSON.parse(response_body)['errors'] || []
      end
    end

    class ClientError < StandardError
      #
      # @param original_exception [HTTP::Error]
      #
      def initialize(original_exception)
        @original_exception = original_exception
      end

      # @return [HTTP::Error]
      attr_reader :original_exception
    end

    #
    # @param myshopify_domain [String]
    #
    def initialize(myshopify_domain)
      @myshopify_domain = myshopify_domain
    end

    # @return [String]
    attr_reader :myshopify_domain

    #
    # Make a GET request to the Shopify API.
    #
    # @param path [String] the endpoint relative to the base URL
    # @param params [Hash] the query params
    #
    # @return [Hash] the JSON response body or `{}`
    #
    # @raise [ClientError] if the request failed
    # @raise [RequestError] if the response status >= 400
    #
    def get(path, params = {})
      request(:get, path, params: params)
    end

    #
    # Make a POST request to the Shopify API with a JSON formatted body.
    #
    # @param path [String] the endpoint relative to the base URL
    # @param data [Hash] the JSON request body
    #
    # @return [Hash] the JSON response body or `{}`
    #
    # @raise [ClientError] if the request failed
    # @raise [RequestError] if the response status >= 400
    #
    def post_json(path, data = {})
      request(:post, path, json: data)
    end

    #
    # Make a PUT request to the Shopify API with a JSON formatted body.
    #
    # @param path [String] the endpoint relative to the base URL
    # @param data [Hash] the JSON request body
    #
    # @return [Hash] the JSON response body or `{}`
    #
    # @raise [ClientError] if the request failed
    # @raise [RequestError] if the response status >= 400
    #
    def put_json(path, data = {})
      request(:put, path, json: data)
    end

    #
    # Make a DELETE request to the Shopify API.
    #
    # @param path [String] the endpoint relative to the base URL
    #
    # @return [Hash] the JSON response body or `{}`
    #
    # @raise [ClientError] if the request failed
    # @raise [RequestError] if the response status >= 400
    #
    def delete(path)
      request(:delete, path)
    end

    private def request(method, path, options = {})
      res = client.__send__(method, url(path), options)
      if res.code >= 400
        raise RequestError.new(method, url(path), options, res), 'bad response code'
      end

      JSON.parse(res.to_s)
    rescue JSON::ParserError
      {}
    rescue HTTP::ConnectionError, HTTP::ResponseError, HTTP::TimeoutError => e
      raise ClientError.new(e), e.message
    end

    private def client
      HTTP.headers(
        'Accept' => 'application/json'
      )
    end

    private def url(path)
      @shop_url ||= "https://#{myshopify_domain}/admin"

      path = path.sub(/^\//, '')
      path = path.sub(/\.json$/, '')

      @shop_url + '/' + path + '.json'
    end
  end
end
