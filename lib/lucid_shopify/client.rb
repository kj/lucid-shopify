# frozen_string_literal: true

require 'lucid_shopify/container'

%w[delete get post put].each { |m| require "lucid_shopify/#{m}_request" }

module LucidShopify
  class Client
    #
    # @param send_request [#call]
    #
    def initialize(send_request: Container[:send_request])
      @send_request = send_request
    end

    #
    # @see DeleteRequest#initialize
    #
    def delete(*args)
      @send_request.(DeleteRequest.new(*args))
    end

    #
    # @see GetRequest#initialize
    #
    def get(*args)
      @send_request.(GetRequest.new(*args))
    end

    #
    # @see PostRequest#initialize
    #
    def post_json(*args)
      @send_request.(PostRequest.new(*args))
    end

    #
    # @see PutRequest#initialize
    #
    def put_json(*args)
      @send_request.(PutRequest.new(*args))
    end
  end
end
