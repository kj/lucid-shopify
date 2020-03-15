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
        end

        # Set a block which is called after the file is downloaded, and around
        # the line by line iteration in {#call}. The block must yield control
        # back to the caller.
        #
        # @return [self]
        #
        # @example
        #   operation.around do |&y|
        #     puts 'Before iteration'
        #     y.()
        #   ensure
        #     puts 'After iteration'
        #   end
        def around(&block)
          @around = block

          self
        end

        # Call the block set by {#around}.
        #
        # @yield inside the wrapper block
        private def call_around(&block)
          @around.respond_to?(:call) ? @around.(&block) : block.()
        end

        # @param query [String] the GraphQL query
        # @param delay [Integer] delay between polling requests in seconds
        # @param http [HTTP::Client]
        #
        # @yield [Hash] each parsed line of JSONL (streamed to limit memory usage)
        def call(query, delay: 1, http: Container[:http], &block)
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

          url = poll(id, delay: delay)

          return if url.nil?

          # TODO: Verify signature?

          begin
            file = Tempfile.new(mode: 0600)
            body = http.get(url).body
            until (chunk = body.readpartial).nil?
              file.write(chunk)
            end
            file.rewind
            call_around do
              file.each_line do |line|
                block.(JSON.parse(line))
              end
            end
          ensure
            file.close
            file.unlink
          end
        end

        # @param id [Integer] of the bulk operation
        # @param delay [Integer]
        #
        # @return [String, nil] the download URL, or nil if the result data is empty
        private def poll(id, delay:)
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
            sleep(delay)

            poll(id, delay: delay)
          end
        end
      end

      # @param client [Client]
      # @param credentials [Credentials]
      #
      # @return [Operation]
      #
      # @example
      #   bulk_request.(client, credentials).around do |&y|
      #     db.transaction { y.() }
      #   end.(<<~QUERY) do |product|
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
      #     db[:products].insert(
      #       id: product['id'],
      #       handle: product['handle'],
      #     )
      #   end
      def call(client, credentials)
        Shopify.assert_api_version!('2019-10')

        Operation.new(client, credentials)
      end
    end
  end
end
