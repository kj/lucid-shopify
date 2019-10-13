# frozen_string_literal: true

RSpec.shared_context 'register webhooks' do
  include_fixtures 'webhooks.yml.erb'

  before do
    webhooks['registered'].each do |webhook|
      Lucid::Shopify.webhooks.register(webhook['topic'], fields: webhook['fields'])
    end
  end
end
