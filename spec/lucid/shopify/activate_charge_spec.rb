# frozen_string_literal: true

module Lucid
  module Shopify
    RSpec.describe ActivateCharge do
      let(:charge) { charge_api['plus accepted'] }
      let(:client) { instance_double('Client') }

      subject(:activate_charge) do
        ActivateCharge.new(
          client: client
        )
      end

      include_fixtures 'charge_api.yml.erb'

      it 'activates a charge via the API' do
        expect(client).to receive(:post_json) do |*args|
          expect(args[0]).to be(credentials)
          expect(args[1]).to eq("recurring_application_charges/#{charge['id']}/activate")
          expect(args[2]).to be(charge)

          {'recurring_application_charge' => charge_api['plus active']}
        end

        active_charge = activate_charge.(credentials, charge)

        expect(active_charge).to eq(charge_api['plus active'])
      end
    end
  end
end
