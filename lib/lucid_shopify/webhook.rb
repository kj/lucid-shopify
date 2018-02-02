# frozen_string_literal: true

require 'json'

module LucidShopify
  class Webhook
    #
    # @param myshopify_domain [String]
    # @param topic [String]
    # @param data [String] the raw JSON request data
    #
    def initialize(myshopify_domain, topic, data)
      @myshopify_domain = myshopify_domain
      @topic = topic
      @data = data
    end

    # @return [String]
    attr_reader :myshopify_domain
    # @return [String]
    attr_reader :topic
    # @return [String]
    attr_reader :data

    #
    # @return [Hash] the parsed JSON data
    #
    def data_hash
      @data_hash ||= JSON.parse(@data)
    end
  end
end
