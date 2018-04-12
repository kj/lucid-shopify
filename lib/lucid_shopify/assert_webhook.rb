# frozen_string_literal: true

require 'base64'
require 'openssl'

require 'lucid_shopify'

module LucidShopify
  class AssertWebhook
    Error = Class.new(Error)

    #
    # Assert that the webhook request originated from Shopify.
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

      raise Error, 'invalid signature' unless digest == hmac
    end
  end
end
