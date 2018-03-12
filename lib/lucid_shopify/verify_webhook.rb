# frozen_string_literal: true

require 'base64'
require 'dry-initializer'
require 'openssl'

require 'lucid_shopify/config'
require 'lucid_shopify/result'

module LucidShopify
  class VerifyWebhook
    extend Dry::Initializer

    # @return [Config]
    option :config, default: proc { LucidShopify.config }

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
      digest = OpenSSL::HMAC.digest(digest, config.shared_secret, data)
      digest = Base64.encode64(digest).strip
      result = digest == hmac

      Result.new(result, result ? nil : 'invalid request')
    end
  end
end
