# frozen_string_literal: true

require 'logger'

require 'lucid/shopify'
require 'lucid/utils'

module Lucid
  module Shopify
    class << self
      # @param options [Hash]
      #
      # @return [Config]
      def configure(options = {})
        @config = Config.new(
          **@config.to_h.compact,
          **options,
        )
      end

      # @param path [String]
      #
      # @return [Config]
      def configure_from_file(path = 'config/shopify.rb')
        options = Utils::ConfigFromFile.new.(path, env_prefix: 'shopify')

        configure(options)
      end

      # @return [Config]
      def config
        @config ||= configure
      end
    end

    class Config < Dry::Struct
      attribute :api_version, Types::String.default('2019-07')
      attribute :logger, Types::Logger.default(Logger.new(File::NULL).freeze)

      # The following attributes may be unnecessary in some private apps.
      attribute? :api_key, Types::String
      attribute? :billing_callback_uri, Types::String
      attribute? :callback_uri, Types::String
      attribute? :scope, Types::String
      attribute? :shared_secret, Types::String
      attribute? :webhook_uri, Types::String
    end

    self.configure
  end
end
