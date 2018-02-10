# frozen_string_literal: true

require 'lucid_shopify/immutable_struct'

module LucidShopify
  #
  # @!attribute [r] api_key
  #   @return [String]
  # @!attribute [r] shared_secret
  #   @return [String]
  # @!attribute [r] scope
  #   @return [String]
  # @!attribute [r] billing_callback_uri
  #   @return [String]
  # @!attribute [r] webhook_uri
  #   @return [String]
  #
  Credentials = ImmutableStruct.new(:api_key, :shared_secret, :scope, :billing_callback_uri, :webhook_uri)
end

class << LucidShopify
  #
  # Assign default API credentials.
  #
  # @param credentials [LucidShopify::Credentials]
  #
  attr_writer :credentials

  #
  # @return [LucidShopify::Credentials]
  #
  # @raise [LucidShopify::MissingCredentialsError] if credentials are unset
  #
  def credentials
    raise MissingCredentialsError unless @credentials

    @credentials
  end
end
