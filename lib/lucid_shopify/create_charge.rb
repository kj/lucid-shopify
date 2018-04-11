# frozen_string_literal: true

require 'lucid_shopify/container'

module LucidShopify
  class CreateCharge
    #
    # @param [#post_json] client
    #
    def initialize(client: Container[:client])
      @client = client
    end

    #
    # Create a new recurring application charge.
    #
    # @param request_credentials [RequestCredentials]
    # @param charge [#to_h]
    #
    # @return [Hash] the pending charge
    #
    def call(request_credentials, charge)
      data = @client.post_json(request_credentials, 'recurring_application_charges', charge.to_h)

      data['recurring_application_charge']
    end
  end
end
