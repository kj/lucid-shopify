# frozen_string_literal: true

require 'lucid_shopify/charge'

module LucidShopify
  RSpec.describe Charge do
    context 'with defaults' do
      let(:attributes) do
        {
          plan_name: 'plus',
          price: 19,
          price_cap: nil,
          price_terms: nil,
          test: false,
          trial_days: nil,
        }
      end

      subject(:charge) { Charge.new(*attributes.values[0, 2]) }

      context '#to_h' do
        subject { charge.to_h }

        it { is_expected.to include(:name) }
        it { is_expected.to include(:price) }
        it { is_expected.not_to include(:capped_amount) }
        it { is_expected.not_to include(:terms) }
        it { is_expected.to include(:return_url) }
        it { is_expected.not_to include(:test) }
      end
    end

    context 'with trial' do
      let(:attributes) do
        {
          plan_name: 'plus',
          price: 19,
          price_cap: nil,
          price_terms: nil,
          test: false,
          trial_days: 7,
        }
      end

      subject(:charge) { Charge.new(*attributes.values[0, 2], trial_days: 7) }

      context '#to_h' do
        subject { charge.to_h }

        it { is_expected.to include(:name) }
        it { is_expected.to include(:price) }
        it { is_expected.not_to include(:capped_amount) }
        it { is_expected.not_to include(:terms) }
        it { is_expected.to include(:return_url) }
        it { is_expected.not_to include(:test) }
        it { is_expected.to include(:trial_days) }
      end
    end

    context 'with test' do
      let(:attributes) do
        {
          plan_name: 'plus',
          price: 19,
          price_cap: nil,
          price_terms: nil,
          test: true,
          trial_days: 7,
        }
      end

      subject(:charge) { Charge.new(*attributes.values[0, 2], test: true) }

      context '#to_h' do
        subject { charge.to_h }

        it { is_expected.to include(:name) }
        it { is_expected.to include(:price) }
        it { is_expected.not_to include(:capped_amount) }
        it { is_expected.not_to include(:terms) }
        it { is_expected.to include(:return_url) }
        it { is_expected.to include(:test) }
      end
    end

    context 'with usage based billing' do
      let(:attributes) do
        {
          plan_name: 'pay as you go',
          price: 10,
          price_cap: 100,
          price_terms: '$1 per 100 units',
          test: false,
          trial_days: 7,
        }
      end

      subject(:charge) { Charge.new(*attributes.values[0, 2], **attributes.select { |k| %i[price_cap price_terms].include?(k) }) }

      context '#to_h' do
        subject { charge.to_h }

        it { is_expected.to include(:name) }
        it { is_expected.to include(:price) }
        it { is_expected.to include(:capped_amount) }
        it { is_expected.to include(:terms) }
        it { is_expected.to include(:return_url) }
        it { is_expected.not_to include(:test) }
        it { is_expected.not_to include(:trial_days) }
      end
    end
  end
end
