# frozen_string_literal: true

require 'dry-initializer'

module LucidShopify
  MissingCredentialsError = Class.new(StandardError)

  class Credentials
    extend Dry::Initializer

    # @return [String]
    param :api_key
    # @return [String]
    param :shared_secret
    # @return [String]
    param :scope
    # @return [String]
    param :billing_callback_uri
    # @return [String]
    param :webhook_uri
  end
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
