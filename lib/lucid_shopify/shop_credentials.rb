# frozen_string_literal: true

require 'lucid_shopify/immutable_struct'

module LucidShopify
  #
  # @!attribute [r] myshopify_domain
  #   @return [String]
  # @!attribute [r] access_token
  #   @return [String]
  #
  ShopCredentials = ImmutableStruct.new(:myshopify_domain, :access_token)
end
