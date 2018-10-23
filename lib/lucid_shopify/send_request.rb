# frozen_string_literal: true

require 'lucid_shopify'

module LucidShopify
  class SendRequest
    class NetworkError < Error
      extend Dry::Initializer

      # @return [HTTP::Error]
      param :original_exception
    end

    #
    # @param http [HTTP::Client]
    # @param strategy [#call, nil] unthrottled by default
    #
    def initialize(http: Container[:http],
                   strategy: ->(*, &block) { block.() })
      @http = http
      @strategy = strategy
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
    def call(request, attempts: default_attempts)
      res = @strategy.(request) do
        res = send(request)

        Response.new(request, res.code, res.headers.to_h, res.to_s)
      end

      res.assert!.data_hash
    rescue HTTP::ConnectionError,
           HTTP::ResponseError,
           HTTP::TimeoutError => e
      raise NetworkError.new(e), e.message if attempts.zero?

      call(request, attempts: attempts - 1)
    end

    #
    # @param request [Request]
    #
    # @return [HTTP::Response]
    #
    private def send(request)
      req = request

      @http.headers(req.http_headers).__send__(req.http_method, req.url, req.options)
    end

    #
    # @return [Integer]
    #
    private def default_attempts
      3
    end
  end
end
