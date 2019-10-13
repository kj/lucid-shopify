# frozen_string_literal: true

require 'lucid/shopify'

module Lucid
  module Shopify
    class Credentials
      extend Dry::Initializer

      # @return [String]
      param :myshopify_domain
      # @return [String, nil] if {nil}, request will be unauthorised
      param :access_token, optional: true
    end
  end
end
