# frozen_string_literal: true

require 'openssl'

require 'lucid_shopify'

module LucidShopify
  class VerifyCallback
    #
    # Verify that the callback request originated from Shopify.
    #
    # @param params_hash [Hash] the request params
    #
    # @return [Result]
    #
    def call(params_hash)
      digest = OpenSSL::Digest::SHA256.new
      digest = OpenSSL::HMAC.hexdigest(digest, LucidShopify.config.shared_secret, encoded_params(params_hash))
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
        [].tap do |param|
          param << k.gsub(/./) { |c| encode_k(c) }
          param << '='
          param << v.gsub(/./) { |c| encode_v(c) }
        end.join
      end.join('&')
    end

    #
    # @param c [String]
    #
    # @return [String]
    #
    private def encode_k(c)
      {'%' => '%25', '&' => '%26', '=' => '%3D'}[c] || c
    end

    #
    # @param c [String]
    #
    # @return [String]
    #
    private def encode_v(c)
      {'%' => '%25', '&' => '%26'}[c] || c
    end
  end
end
