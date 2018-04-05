# frozen_string_literal: true

require 'json'

require 'lucid_shopify'

module LucidShopify
  class Webhook
    extend Dry::Initializer

    # @return [String]
    param :myshopify_domain
    # @return [String]
    param :topic
    # @return [String]
    param :data
    # @return [Hash] the parsed request body
    param :data_hash, default: proc { parse_data }

    #
    # @return [Hash]
    #
    private def parse_data
      JSON.parse(data)
    rescue JSON::ParserError
      {}
    end
  end
end
