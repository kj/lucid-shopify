# frozen_string_literal: true

require 'lucid_shopify/result'

module LucidShopify
  RSpec.describe Result do
    context 'without error' do
      subject(:result) { Result.new('foo') }

      it { is_expected.to have_attributes(value: 'foo') }
      it { is_expected.to have_attributes(error: nil) }
      it { is_expected.to satisfy('succeed', &:success?) }
      it { is_expected.not_to satisfy('fail', &:failure?) }
    end

    context 'with error' do
      subject(:result) { Result.new('foo', 'bar') }

      it { is_expected.to have_attributes(value: 'foo') }
      it { is_expected.to have_attributes(error: 'bar') }
      it { is_expected.not_to satisfy('succeed', &:success?) }
      it { is_expected.to satisfy('fail', &:failure?) }
    end
  end
end
