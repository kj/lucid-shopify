# frozen_string_literal: true

require 'lucid_shopify'

module LucidShopify
  #
  # @example Subclass to provide application defaults
  #   class Charge < LucidShopify::Charge
  #     def initialize(shop)
  #       super('Application name',
  #             9,
  #             test: test?,
  #             trial_days: shop.trial_started_at?.nil? ? 30 : nil)
  #     end
  #
  #     def test?
  #       # ...
  #     end
  #   end
  #
  class Charge
    #
    # @param plan_name [String]
    # @param price [Integer]
    # @param price_cap [Integer] requires price_terms
    # @param price_terms [String] requires price_cap
    # @param test [Boolean] is this a test_charge?
    # @param trial_days [Integer]
    #
    def initialize(plan_name,
                   price,
                   price_cap: nil,
                   price_terms: nil,
                   test: false,
                   trial_days: nil)
      @plan_name = plan_name
      @price = price
      @price_cap = price_cap
      @price_terms = price_terms
      @test = test
      @trial_days = trial_days

      freeze
    end

    #
    # Map to the Shopify API structure.
    #
    # @return [Hash]
    #
    def to_h
      {}.tap do |h|
        h[:name] = @plan_name
        h[:price] = @price
        h[:capped_amount] = @price_cap if usage_based_billing?
        h[:terms] = @price_terms if usage_based_billing?
        h[:return_url] = LucidShopify.config.billing_callback_uri
        h[:test] = @test if @test
        h[:trial_days] = @trial_days if @trial_days
      end
    end

    #
    # @return [Boolean]
    #
    private def usage_based_billing?
      @price_cap && @price_terms
    end
  end
end
