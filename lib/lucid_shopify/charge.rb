# frozen_string_literal: true

require 'lucid_shopify/authorized_client'
require 'lucid_shopify/credentials'

module LucidShopify
  class Charge
    TRIAL_DAYS = 7

    #
    # @param client [AuthorizedClient]
    # @param credentials [Credentials]
    # @param test [Boolean] is this a test charge?
    # @param trial [Boolean]
    #
    def initialize(client, credentials: LucidShopify.credentials, test: false, trial: false)
      @client = client
      @credentials = credentials
      @test = test
      @trial = trial
    end

    # @return [AuthorizedClient]
    attr_reader :client
    # @return [Credentials]
    attr_reader :credentials
    # @return [Boolean]
    attr_reader :test
    # @return [Boolean]
    attr_reader :trial

    #
    # Create a new recurring application charge.
    #
    # @return [Hash] the pending charge
    #
    def create
      data = client.post_json(create_path, create_data)

      data['recurring_application_charge']
    end

    private def create_path
      'recurring_application_charges'
    end

    private def create_data
      {
        recurring_application_charge: {
          name: 'Microsites',
          price: price,
          capped_amount: price_cap,
          terms: price_terms,
          return_url: credentials.billing_callback_uri,
          test: test,
          trial_days: trial ? TRIAL_DAYS : 0,
        },
      }
    end

    #
    # Usage-based charge.
    #
    private def price
      0
    end

    private def price_cap
      50
    end

    #
    # TODO: implement this (see Dropbox Paper doc).
    #
    private def price_terms
      '$0.007 per hour (~$5 per month) for each published microsite'
    end

    #
    # Get a recurring application charge.
    #
    # @param charge_id [String]
    #
    # @return [Hash] the charge
    #
    def get(charge_id)
      data = client.get(get_path(charge_id))

      data['recurring_application_charge']
    end

    private def get_path(charge_id)
      "recurring_application_charges/#{charge_id}"
    end

    #
    # Activate a recurring application charge.
    #
    # @param charge [Hash] an accepted charge received from Shopify (callback)
    #
    # @return [Hash] the active charge
    #
    def activate(charge)
      data = client.post_json(activate_path(charge['id']), charge)

      data['recurring_application_charge']
    end

    private def activate_path(charge_id)
      "recurring_application_charges/#{charge_id}/activate"
    end
  end
end
