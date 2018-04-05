# frozen_string_literal: true

require 'lucid_shopify/container'

module LucidShopify
  class ActivateCharge
    extend Dry::Initializer

    # @return [#post_json]
    option :client, default: proc { Container[:client] }

    #
    # Activate a recurring application charge.
    #
    # @param request_credentials [RequestCredentials]
    # @param charge [Hash, #to_h] an accepted charge received from Shopify via callback
    #
    # @return [Hash] the active charge
    #
    def call(request_credentials, charge)
      data = client.post_json(request_credentials, "recurring_application_charges/#{charge_id}/activate", charge.to_h)

      data['recurring_application_charge']
    end
  end
end
