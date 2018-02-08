# frozen_string_literal: true

require 'openssl'

require 'lucid_shopify/predicate_result'

module LucidShopify
  class VerifyCallback
    #
    # @param credentials [LucidShopify::Credentials]
    #
    def initialize(credentials: LucidShopify.credentials)
      @credentials = credentials
    end

    # @return [LucidShopify::Credentials]
    attr_reader :credentials

    #
    # Verify that the callback request originated from Shopify.
    #
    # @param params_hash [Hash] the request params
    #
    # @return [PredicateResult]
    #
    def call(params_hash)
      digest = OpenSSL::Digest::SHA256.new
      digest = OpenSSL::HMAC.hexdigest(digest, credentials.shared_secret, encoded_params(params_hash))

      PredicateResult.new(digest == params_hash[:hmac])
    end

    private def encoded_params(params_hash)
      params_hash.reject do |k, _|
        k == :hmac
      end.map do |k, v|
        encode_k(k) + '=' + encode_v(v)
      end.join('&')
    end

    private def encode_k(k)
      k.to_s.gsub(/./) do |chr|
        {'%' => '%25', '&' => '%26', '=' => '%3D'}[chr] || chr
      end
    end

    private def encode_v(v)
      v.gsub(/./) do |chr|
        {'%' => '%25', '&' => '%26'}[chr] || chr
      end
    end
  end
end
