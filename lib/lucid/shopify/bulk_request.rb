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

      class Operation
        include Dry::Initializer.define -> do
          # @return [Client]
          param :client
          # @return [Credentials]
          param :credentials
          # @return [String]
          param :id
        end

        # Wait for the operation to complete, then download the JSONL result
        # data which is yielded as an {Enumerator} to the block. The data is
        # streamed and parsed line by line to limit memory usage.
        #
        # @param delay [Integer] delay between polling requests in seconds
        # @param http [HTTP::Client]
        #
        # @yield [Enumerator<Hash>] yields each parsed line of JSONL
        def call(delay: 1, http: Container[:http], &block)
          url = loop do
            status, url = poll

            case status
            when 'CANCELED'
              raise CanceledOperationError
            when 'EXPIRED'
              raise ExpiredOperationError
            when 'FAILED'
              raise FailedOperationError
            when 'COMPLETED'
              break url
            else
              sleep(delay)
            end
          end

          return if url.nil?

          # TODO: Verify signature?

          begin
            file = Tempfile.new(mode: 0600)
            body = http.get(url).body
            until (chunk = body.readpartial).nil?
              file.write(chunk)
            end
            file.rewind
            block.(Enumerator.new do |y|
              file.each_line { |line| y << JSON.parse(line) }
            end)
          ensure
            file.close
            file.unlink
          end
        end

        # Cancel the bulk operation.
        def cancel
          client.post_graphql(credentials, <<~QUERY)
            mutation {
              bulkOperationCancel(id: "#{id}") {
                userErrors {
                  field
                  message
                }
              }
            }
          QUERY

          loop do
            status, _ = poll

            break unless status == 'CANCELING'
          end
        end

        # @return [Array(String, String | nil)] the operation status and the
        #   download URL, or nil if the result data is empty
        private def poll
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

          [
            op['status'],
            op['url'],
          ]
        end
      end

      # Create and start a new bulk operation via the GraphQL API.
      #
      # @param client [Client]
      # @param credentials [Credentials]
      # @param query [String] the GraphQL query
      #
      # @return [Operation]
      #
      # @example
      #   bulk_request.(client, credentials, <<~QUERY).() do |products|
      #     {
      #       products {
      #         edges {
      #           node {
      #             id
      #             handle
      #           }
      #         }
      #       }
      #     }
      #   QUERY
      #     db.transaction do
      #       products.each do |product|
      #         db[:products].insert(
      #           id: product['id'],
      #           handle: product['handle'],
      #         )
      #       end
      #     end
      #   end
      def call(client, credentials, query)
        Shopify.assert_api_version!('2019-10')

        op = client.post_graphql(credentials, <<~QUERY)['data']['currentBulkOperation']
          {
            currentBulkOperation {
              id
              status
              url
            }
          }
        QUERY

        Operation.new(client, credentials, op['id']).cancel if op && op['status'] == 'RUNNING'

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

        Operation.new(client, credentials, id)
      end
    end
  end
end
