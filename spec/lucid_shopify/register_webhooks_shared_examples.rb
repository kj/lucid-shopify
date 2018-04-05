# frozen_string_literal: true

require 'lucid_shopify/create_all_webhooks'

RSpec.shared_examples 'register webhooks' do
  include_fixtures 'webhooks_registered.yml'
  include_fixtures 'webhooks_shopify.yml.erb'

  before do
    webhooks_registered.each { |w| LucidShopify.webhooks << w }
  end
end
