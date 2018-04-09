# frozen_string_literal: true

require 'lucid_shopify/activate_charge'

RSpec.describe LucidShopify::ActivateCharge do
  let(:charge) { charge_api['plus_accepted'] }
  let(:client) { double }

  subject(:activate_charge) do
    LucidShopify::ActivateCharge.new(
      client: client
    )
  end

  include_fixtures 'charge_api.yml.erb'

  it 'activates a charge via the API' do
    args = [credentials, "recurring_application_charges/#{charge['id']}/activate", charge]
    data = {'recurring_application_charge' => charge_api['plus_active']}
    expect(client).to receive(:post_json).with(*args).and_return(data)

    active_charge = activate_charge.(credentials, charge)

    expect(active_charge).to eq(charge_api['plus_active'])
  end
end
