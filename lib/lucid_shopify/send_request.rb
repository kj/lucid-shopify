# frozen_string_literal: true

require 'http'

require 'lucid_shopify'

module LucidShopify
  class SendRequest
    class NetworkError < Error
      extend Dry::Initializer

      # @return [HTTP::Error]
      param :original_exception
    end

    #
    # @param request [Request]
    # @param attempts [Integer] additional request attempts on client error
    #
    # @return [Hash] the parsed response body
    #
    # @raise [NetworkError] if the request failed all attempts
    # @raise [Response::ClientError] for status 4xx
    # @raise [Response::ServerError] for status 5xx
    #
    def call(request, attempts = default_attempts)
      req = request
      res = send(req.http_method, req.url, req.options)
      res = Response.new(req, res.code, res.headers.to_h, res.to_s)

      res.assert!.data_hash
    rescue *http_network_errors => e
      raise NetworkError.new(e), e.message if attempts.zero?

      call(request, attempts - 1)
    end

    #
    # @return [HTTP::Response]
    #
    private def send(http_method, url, options)
      HTTP.headers(request.headers).__send__(http_method, url, options)
    end

    #
    # @return [Integer]
    #
    private def default_attempts
      3
    end

    #
    # @return [Array<Class>]
    #
    private def http_network_errors
      [
        HTTP::ConnectionError,
        HTTP::ResponseError,
        HTTP::TimeoutError,
      ]
    end
  end
end
