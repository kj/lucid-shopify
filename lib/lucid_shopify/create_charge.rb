# frozen_string_literal: true

require 'dry-initializer'

require 'lucid_shopify/client'

module LucidShopify
  class CreateCharge
    extend Dry::Initializer

    # @return [Client]
    option :client, default: proc { Client.new }

    #
    # Create a new recurring application charge.
    #
    # @param request_credentials [RequestCredentials]
    # @param charge [Hash, #to_h]
    #
    # @return [Hash] the pending charge
    #
    def call(request_credentials, charge)
      data = client.post_json(request_credentials, 'recurring_application_charge', charge.to_h)

      data['recurring_application_charge']
    end
  end
end
