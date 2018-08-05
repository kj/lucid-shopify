# frozen_string_literal: true

module LucidShopify
  RSpec.describe WebhookList do
    let(:webhooks) do
      [
        {topic: 'orders/create', fields: 'id,tags'},
        {topic: 'orders/update', fields: 'id,tags'},
      ]
    end

    subject(:webhook_list) { WebhookList.new }

    it 'registers webhooks' do
      webhooks.each { |w| webhook_list.register(w[:topic], fields: w[:fields]) }

      expect { |b| webhook_list.each(&b) }.to yield_successive_args(*webhooks)
    end
  end
end
