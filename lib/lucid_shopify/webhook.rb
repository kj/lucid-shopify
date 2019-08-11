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

    #
    # @return [Hash]
    #
    def data_hash
      @data_hash ||= JSON.parse(data)
    rescue JSON::ParserError
      {}
    end

    #
    # @see Hash#each
    #
    def each(&block)
      data_hash.each(&block)
    end

    #
    # @param key [String]
    #
    # @return [Object]
    #
    def [](key)
      data_hash[key]
    end

    alias_method :to_h, :data_hash

    #
    # @return [Hash]
    #
    def as_json(*)
      to_h
    end

    #
    # @return [String]
    #
    def to_json(*args)
      as_json.to_json(*args)
    end
  end
end
