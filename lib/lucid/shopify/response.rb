# frozen_string_literal: true

require 'json'

require 'lucid/shopify'

module Lucid
  module Shopify
    class Response
      # @abstract
      class Error < Error
        extend Dry::Initializer

        # @return [Request]
        param :request
        # @return [Response]
        param :response

        # @return [String]
        def message
          if response.errors?
            "bad response (#{response.status_code}) '#{response.error_messages.first}'"
          else
            "bad response (#{response.status_code})"
          end
        end
      end

      ClientError = Class.new(Error)
      ServerError = Class.new(Error)
      ShopError = Class.new(Error)

      extend Dry::Initializer

      include Enumerable

      # @return [Request] the original request
      param :request
      # @return [Integer]
      param :status_code
      # @return [Hash]
      param :headers
      # @return [String]
      param :data

      # @return [Hash]
      param :link, default: -> { build_link }

      # @return [Hash]
      def build_link
        Container[:parse_link_header].(headers['Link'])
      end

      # Request the next page of a GET request, if any.
      #
      # @param client [Client]
      #
      # @return [Response, nil]
      def next(client: Container[:client], limit: nil)
        return nil unless link[:next]

        limit = limit ||
                request.options.dig(:params, :limit) ||
                link[:next][:limit]
        client.get(request.credentials, request.path, {**link[:next], limit: limit})
      end

      # Request the previous page of a GET request, if any.
      #
      # @param client [Client]
      #
      # @return [Response, nil]
      def previous(client: Container[:client], limit: nil)
        return nil unless link[:previous]

        limit = limit ||
                request.options.dig(:params, :limit) ||
                link[:previous][:limit]
        client.get(request.credentials, request.path, {**link[:previous], limit: limit})
      end

      # The parsed response body.
      #
      # @return [Hash]
      def data_hash
        return {} unless json?

        @data_hash ||= JSON.parse(data)
      end

      # @return [Boolean]
      private def json?
        headers['Content-Type'] =~ /application\/json/ && !data.empty?
      end

      # @return [self]
      #
      # @raise [ClientError] for status 4xx
      # @raise [ServerError] for status 5xx
      #
      # @note https://help.shopify.com/en/api/getting-started/response-status-codes
      def assert!
        case status_code
        when 402
          raise ShopError.new(request, self), 'Shop is frozen, awaiting payment'
        when 423
          raise ShopError.new(request, self), 'Shop is locked'
        when 400..499
          raise ClientError.new(request, self)
        when 500..599
          raise ServerError.new(request, self)
        end

        # GraphQL always has status 200.
        if request.is_a?(PostGraphQLRequest) && errors?
          raise ClientError.new(request, self)
        end

        self
      end

      # @return [Boolean]
      def success?
        status_code.between?(200, 299)
      end

      # @return [Boolean]
      def failure?
        !success?
      end

      # @return [Boolean]
      def errors?
        return user_errors? if user_errors?

        data_hash.has_key?('errors') # should be only on 422
      end

      # GraphQL user errors.
      #
      # @return [Boolean]
      private def user_errors?
        errors = data_hash.dig('data', 'userErrors')

        !errors.nil? && !errors.empty?
      end

      # A string rather than an object is returned by Shopify in the case of,
      # e.g., 'Not found'. In this case, we return it under the 'resource' key.
      #
      # @return [Hash]
      def errors
        errors = data_hash['errors']
        errors = case
        when errors.nil?
          {}
        when errors.is_a?(String)
          {'resource' => errors}
        else
          errors
        end

        errors.merge(user_errors)
      end

      # GraphQL user errors.
      #
      # @return [Hash]
      private def user_errors
        errors = data_hash.dig('data', 'userErrors')
        return {} if errors.nil? || errors.empty?
        errors.map do |error|
          [
            error['field'],
            error['message'],
          ]
        end.to_h
      end

      # @return [Array<String>]
      def error_messages
        errors.map { |field, message| "#{field} #{message}" }
      end

      # @param messages [Array<String>]
      #
      # @return [Boolean]
      def error_message?(messages)
        messages.any? { |message| error_messages.include?(message) }
      end

      # @see Hash#each
      def each(&block)
        data_hash.each(&block)
      end

      # @param key [String]
      #
      # @return [Object]
      def [](key)
        data_hash[key]
      end

      alias_method :to_h, :data_hash

      # @return [Hash]
      def as_json(*)
        to_h
      end

      # @return [String]
      def to_json(*args)
        as_json.to_json(*args)
      end
    end
  end
end
