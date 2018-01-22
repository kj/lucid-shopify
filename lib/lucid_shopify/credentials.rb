module LucidShopify
  #
  # @!attribute [rw] api_key
  #   @return [String]
  # @!attribute [rw] shared_secret
  #   @return [String]
  # @!attribute [rw] scope
  #   @return [String]
  # @!attribute [rw] billing_callback_uri
  #   @return [String]
  # @!attribute [rw] webhook_uri
  #   @return [String]
  #
  Credentials = Struct.new(:api_key, :shared_secret, :scope, :billing_callback_uri, :webhook_uri)
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
