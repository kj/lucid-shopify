# frozen_string_literal: true

require 'json'

require 'lucid_shopify'

module LucidShopify
  class Response
    #
    # @abstract
    #
    class Error < Error
      extend Dry::Initializer

      # @return [Request]
      param :request
      # @return [Response]
      param :response

      #
      # @return [String]
      #
      def message
        "bad response (#{response.status_code})"
      end
    end

    ClientError = Class.new(Error)
    ServerError = Class.new(Error)

    extend Dry::Initializer

    # @return [Request] the original request
    param :request
    # @return [Integer]
    param :status_code
    # @return [Hash]
    param :headers
    # @return [String]
    param :data
    # @return [Hash] the parsed response body
    param :data_hash, default: -> { parse_data }

    #
    # @return [Hash]
    #
    private def parse_data
      return {} unless json?

      JSON.parse(data)
    end

    #
    # @return [Boolean]
    #
    private def json?
      headers['Content-Type'] =~ /application\/json/
    end

    #
    # @return [self]
    #
    # @raise [ClientError] for status 4xx
    # @raise [ServerError] for status 5xx
    #
    def assert!
      case status_code
      when 400..499
        raise ClientError.new(request, self)
      when 500..599
        raise ServerError.new(request, self)
      end

      self
    end

    #
    # @return [Boolean]
    #
    def success?
      status_code.between?(200, 299)
    end

    #
    # @return [Boolean]
    #
    def failure?
      !success?
    end

    #
    # @return [Boolean]
    #
    def errors?
      data_hash.has_key?('errors')
    end

    #
    # A string rather than an object is returned by Shopify in the case of,
    # e.g., 'Not found'.
    #
    # @return [Hash, String]
    #
    def errors
      data_hash['errors']
    end
  end
end
