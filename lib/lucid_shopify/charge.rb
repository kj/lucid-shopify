# frozen_string_literal: true

require 'dry-initializer'

require 'lucid_shopify/config'

module LucidShopify
  #
  # Provides a convenient way to build the charge hash for {CreateCharge}.
  #
  class Charge
    extend Dry::Initializer

    # @return [String]
    param :plan_name
    # @return [Integer]
    param :price
    # @return [Integer] requires price_terms
    option :price_cap, optional: true
    # @return [String] requires price_cap
    option :price_terms, optional: true
    # @return [Boolean] is this a test charge?
    option :test, default: proc { false }
    # @return [Integer]
    option :trial_days, default: proc { 7 }
    # @return [Config]
    option :config, default: proc { LucidShopify.config }

    #
    # Map to the Shopify API structure.
    #
    # @return [Hash]
    #
    def to_h
      {}.tap do |hash|
        hash[:name] = plan_name
        hash[:price] = price
        hash[:capped_amount] = price_cap if usage_based_billing?
        hash[:terms] = price_terms if usage_based_billing?
        hash[:return_url] = config.billing_callback_uri
        hash[:test] = test if test
        hash[:trial_days] = trial_days if trial_days
      end
    end

    #
    # @return [Boolean]
    #
    private def usage_based_billing?
      price_cap && price_terms
    end
  end
end
