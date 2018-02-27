# frozen_string_literal: true

require 'openssl'

require 'lucid_shopify/credentials'
require 'lucid_shopify/result'

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
    # @return [Result]
    #
    def call(params_hash)
      digest = OpenSSL::Digest::SHA256.new
      digest = OpenSSL::HMAC.hexdigest(digest, credentials.shared_secret, encoded_params(params_hash))
      result = digest == params_hash[:hmac]

      Result.new(result, result ? nil : 'invalid request')
    end

    #
    # @param params_hash [Hash]
    #
    # @return [String]
    #
    private def encoded_params(params_hash)
      params_hash.reject do |k, _|
        k == :hmac
      end.map do |k, v|
        encode_key(k) + '=' + encode_value(v)
      end.join('&')
    end

    #
    # @param k [String, Symbol]
    #
    # @return [String]
    #
    private def encode_key(k)
      k.to_s.gsub(/./) do |chr|
        {'%' => '%25', '&' => '%26', '=' => '%3D'}[chr] || chr
      end
    end

    #
    # @param v [String]
    #
    # @return [String]
    #
    private def encode_value(v)
      v.gsub(/./) do |chr|
        {'%' => '%25', '&' => '%26'}[chr] || chr
      end
    end
  end
end
