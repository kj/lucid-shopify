# frozen_string_literal: true

require 'base64'
require 'openssl'

module LucidShopify
  class VerifyWebhook
    #
    # @param data [String] the signed request data
    # @param hmac [String] the signature
    # @param credentials [LucidShopify::Credentials]
    #
    def initialize(data, hmac, credentials: LucidShopify.credentials)
      @credentials = credentials
      @data = data
      @hmac = hmac
    end

    # @return [LucidShopify::Credentials]
    attr_reader :credentials

    #
    # Verify that the webhook request originated from Shopify.
    #
    # @return [Boolean] true if verified, otherwise false
    #
    def verified?
      digest = OpenSSL::Digest::SHA256.new
      digest = OpenSSL::HMAC.digest(digest, credentials.shared_secret, @data)
      digest = Base64.encode64(digest).strip
      digest == @hmac
    end
  end
end
