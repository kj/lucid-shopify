# frozen_string_literal: true

require 'json'

require 'lucid_shopify/immutable_struct'

module LucidShopify
  #
  # @!attribute [r] myshopify_domain
  #   @return [String]
  # @!attribute [r] topic
  #   @return [String]
  # @!attribute [r] data
  #   @return [String] the raw JSON request data
  #
  Webhook = ImmutableStruct.new(:myshopify_domain, :topic, :data) do
    def post_initialize
      @data_hash = JSON.parse(data)
    end

    #
    # @return [Hash] the parsed JSON data
    #
    attr_reader :data_hash
  end
end
