# frozen_string_literal: true

require 'json'
require 'lucid/shopify'

module Lucid
  module Shopify
    class BulkRequest
      OperationError = Class.new(Error)

      CanceledOperationError = Class.new(OperationError)
      ExpiredOperationError = Class.new(OperationError)
      FailedOperationError = Class.new(OperationError)
      ObsoleteOperationError = Class.new(OperationError)

      # @param http [HTTP::Client]
      def initialize(http: Container[:http])
        @http = http
      end

      # @param client [Client]
      # @param credentials [Credentials]
      # @param query [String]
      #
      # @yield [String] each parsed line of JSONL (streamed to limit memory usage)
      #
      # @example
      #   bulk_request.(client, credentials, <<~QUERY)
      #     {
      #       products {
      #         edges {
      #           node {
      #             id
      #             handle
      #             publishedAt
      #           }
      #         }
      #       }
      #     }
      #   QUERY
      def call(client, credentials, query, &block)
        Shopify.assert_api_version!('2019-10')

        id = client.post_graphql(credentials, <<~QUERY)['data']['bulkOperationRunQuery']['bulkOperation']['id']
          mutation {
            bulkOperationRunQuery(
              query: """
                #{query}
              """
            ) {
              bulkOperation {
                id
              }
              userErrors {
                field
                message
              }
            }
          }
        QUERY

        url = poll(client, credentials, id)

        # TODO: Verify signature?

        begin
          file = Tempfile.new(mode: 0600)
          body = @http.get(url).body
          until (chunk = body.readpartial).nil?
            file.write(chunk)
          end
          file.rewind
          file.each_line do |line|
            block.call(JSON.parse(line))
          end
        ensure
          file.close
          file.unlink
        end
      end

      # @param client [Client]
      # @param credentials [Credentials]
      # @param id [Integer] of the bulk operation
      #
      # @return [String] the download URL
      private def poll(client, credentials, id)
        op = client.post_graphql(credentials, <<~QUERY)['data']['currentBulkOperation']
          {
            currentBulkOperation {
              id
              status
              url
            }
          }
        QUERY

        raise ObsoleteOperationError if op['id'] != id

        case op['status']
        when 'CANCELED'
          raise CanceledOperationError
        when 'EXPIRED'
          raise ExpiredOperationError
        when 'FAILED'
          raise FailedOperationError
        when 'COMPLETED'
          op['url']
        else
          poll(client, credentials, id)
        end
      end
    end
  end
end
