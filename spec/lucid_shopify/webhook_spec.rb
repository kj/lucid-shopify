# frozen_string_literal: true

require 'lucid_shopify/webhook'

module LucidShopify
  RSpec.describe Webhook do
    let(:myshopify_domain) { 'example.myshopify.com' }
    let(:topic) { 'shop/update' }
    let(:data) { '{"name": "Example"}' }

    subject(:webhook) { Webhook.new(myshopify_domain, topic, data) }

    it { is_expected.to have_attributes(myshopify_domain: myshopify_domain) }
    it { is_expected.to have_attributes(topic: topic) }
    it { is_expected.to have_attributes(data: data) }
    it { is_expected.to have_attributes(data_hash: {'name' => 'Example'}) }

    context 'with invalid JSON' do
      let(:data) { 'plain text' }

      it { is_expected.to have_attributes(data: data) }
      it { is_expected.to have_attributes(data_hash: {}) }
    end
  end
end
