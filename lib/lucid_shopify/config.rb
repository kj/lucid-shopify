# frozen_string_literal: true

require 'forwardable'
require 'logger'

require 'lucid_shopify'

module LucidShopify
  NotConfiguredError = Class.new(Error)

  class << self
    extend Forwardable

    def_delegators(
      :config,
      :api_version,
      :api_key,
      :shared_secret,
      :scope,
      :billing_callback_uri,
      :webhook_uri,
      :logger
    )

    # @param config [Config]
    attr_writer :config

    #
    # @return [Config]
    #
    # @raise [NotConfiguredError] if credentials are unset
    #
    def config
      raise NotConfiguredError unless @config

      @config
    end
  end

  class Config
    extend Dry::Initializer

    # @return [String]
    param :api_version
    # @return [String]
    param :api_key
    # @return [String]
    param :shared_secret
    # @return [String]
    param :scope
    # @return [String]
    param :callback_uri
    # @return [String]
    param :billing_callback_uri
    # @return [String]
    param :webhook_uri

    #
    # @return [Logger]
    #
    def logger
      @logger ||= Logger.new(File::NULL)
    end

    #
    # @param new_logger [Logger]
    #
    def logger=(new_logger)
      raise ArgumentError, 'not a Logger' unless new_logger.is_a?(Logger)

      @logger = new_logger
    end

    PRIVATE_APP = new(ENV.fetch('SHOPIFY_API_VERSION', '2019-04'), '', '', '', '', '', '') # 2019-04 was the first versioned API
  end

  self.config = Config::PRIVATE_APP
end
