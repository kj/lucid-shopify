# frozen_string_literal: true

require 'lucid_shopify/create_all_webhooks'

RSpec.shared_examples 'register webhooks' do
  include_fixtures 'webhooks.yml.erb'

  before do
    webhooks['registered'].each { |w| LucidShopify.webhooks << w }
  end
end
