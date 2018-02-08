# frozen_string_literal: true

require 'base64'
require 'openssl'

require 'lucid_shopify/predicate_result'

module LucidShopify
  class VerifyWebhook
    Error = Class.new(StandardError)

    #
    # @param credentials [LucidShopify::Credentials]
    #
    def initialize(credentials: LucidShopify.credentials)
      @credentials = credentials
    end

    # @return [LucidShopify::Credentials]
    attr_reader :credentials

    #
    # Verify that the webhook request originated from Shopify.
    #
    # @param data [String] the signed request data
    # @param hmac [String] the signature
    #
    # @return [PredicateResult]
    #
    def call(data, hmac)
      digest = OpenSSL::Digest::SHA256.new
      digest = OpenSSL::HMAC.digest(digest, credentials.shared_secret, data)
      digest = Base64.encode64(digest).strip

      PredicateResult.new(digest == hmac)
    end
  end
end
