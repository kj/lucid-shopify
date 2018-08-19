# frozen_string_literal: true

require 'lucid_shopify/container'

module LucidShopify
  class CreateCharge
    #
    # @param client [#post_json]
    #
    def initialize(client: Container[:client])
      @client = client
    end

    #
    # Create a new recurring application charge.
    #
    # @param credentials [Credentials]
    # @param charge [Hash]
    #
    # @return [Hash] the pending charge
    #
    def call(credentials, charge)
      data = @client.post_json(credentials, 'recurring_application_charges', post_data(charge))

      data['recurring_application_charge']
    end

    #
    # @param charge [Hash]
    #
    # @return [Hash]
    #
    private def post_data(charge)
      {
        'recurring_application_charge' => {
          'return_url' => LucidShopify.config.billing_callback_uri
        }.merge(charge.transform_keys(&:to_s)),
      }
    end
  end
end
