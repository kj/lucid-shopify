# frozen_string_literal: true

require 'base64'
require 'openssl'

require 'lucid_shopify'

module LucidShopify
  class VerifyWebhook
    #
    # Verify that the webhook request originated from Shopify.
    #
    # @param data [String] the signed request data
    # @param hmac [String] the signature
    #
    # @return [Result]
    #
    def call(data, hmac)
      digest = OpenSSL::Digest::SHA256.new
      digest = OpenSSL::HMAC.digest(digest, LucidShopify.config.shared_secret, data)
      digest = Base64.encode64(digest).strip
      result = digest == hmac

      Result.new(result, result ? nil : 'invalid request')
    end
  end
end
