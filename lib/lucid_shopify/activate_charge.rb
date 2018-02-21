# frozen_string_literal: true

require 'dry-initializer'

require 'lucid_shopify/client'

module LucidShopify
  class ActivateCharge
    extend Dry::Initializer

    # @return [Client]
    option :client, default: proc { Client.new }

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
