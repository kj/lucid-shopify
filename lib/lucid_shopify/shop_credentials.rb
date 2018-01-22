module LucidShopify
  #
  # @!attribute [rw] myshopify_domain
  #   @return [String]
  # @!attribute [rw] access_token
  #   @return [String]
  #
  ShopCredentials = Struct.new(:myshopify_domain, :access_token)
end
