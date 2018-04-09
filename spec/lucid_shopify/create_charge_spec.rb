# frozen_string_literal: true

require 'lucid_shopify/create_charge'

RSpec.describe LucidShopify::CreateCharge do
  let(:client) { double('client') }

  subject(:create_charge) do
    LucidShopify::CreateCharge.new(
      client: client
    )
  end

  include_fixtures 'charge_api.yml.erb'

  it 'creates a charge via the API' do
    args = [credentials, 'recurring_application_charges', charge_api['plus']]
    data = {'recurring_application_charge' => charge_api['plus_accepted']}
    expect(client).to receive(:post_json).with(*args).and_return(data)

    new_charge = create_charge.(credentials, charge_api['plus'])

    expect(new_charge).to eq(charge_api['plus_accepted'])
  end
end
