# frozen_string_literal: true

require 'lucid_shopify/send_request'

%w(delete get post put).each do |method|
  require "lucid_shopify/#{method}_request"
end

module LucidShopify
  class Client
    #
    # @param send_request [SendRequest]
    #
    def initialize(send_request: SendRequest.new)
      @send_request = send_request
    end

    # @return [SendRequest]
    attr_reader :send_request

    #
    # @see {DeleteRequest#initialize}
    #
    def delete(*args)
      send_request.(DeleteRequest.new(*args))
    end

    #
    # @see {GetRequest#initialize}
    #
    def get(*args)
      send_request.(GetRequest.new(*args))
    end

    #
    # @see {PostRequest#initialize}
    #
    def post_json(*args)
      send_request.(PostRequest.new(*args))
    end
    #
    # @see {PutRequest#initialize}
    #
    def put_json(*args)
      send_request.(PutRequest.new(*args))
    end
  end
end
