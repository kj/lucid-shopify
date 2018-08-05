# frozen_string_literal: true

RSpec.shared_context 'register webhooks' do
  include_fixtures 'webhooks.yml.erb'

  before do
    webhooks['registered'].each do |webhook|
      LucidShopify.webhooks.register(webhook['topic'], fields: webhook['fields'])
    end
  end
end
