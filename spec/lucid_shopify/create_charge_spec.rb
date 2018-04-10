# frozen_string_literal: true

require 'lucid_shopify/create_charge'

RSpec.describe LucidShopify::CreateCharge do
  let(:charge) { charge_api['plus'] }
  let(:client) { instance_double('LucidShopify::Client') }

  subject(:create_charge) do
    LucidShopify::CreateCharge.new(
      client: client
    )
  end

  include_fixtures 'charge_api.yml.erb'

  it 'creates a charge via the API' do
    expect(client).to receive(:post_json) do |*args|
      expect(args[0]).to be(credentials)
      expect(args[1]).to eq('recurring_application_charges')
      expect(args[2]).to eq(charge)

      {'recurring_application_charge' => charge_api['plus accepted']}
    end

    new_charge = create_charge.(credentials, charge)

    expect(new_charge).to eq(charge_api['plus accepted'])
  end
end
