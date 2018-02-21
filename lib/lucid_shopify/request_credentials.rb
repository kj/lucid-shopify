# frozen_string_literal: true

require 'dry-initializer'

module LucidShopify
  class RequestCredentials
    extend Dry::Initializer

    # @return [String]
    param :myshopify_domain
    # @return [String, nil] if {nil}, request will be unauthorized
    param :access_token, optional: true
  end
end
