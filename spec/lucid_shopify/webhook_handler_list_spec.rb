# frozen_string_literal: true

module LucidShopify
  RSpec.describe WebhookHandlerList do
    let(:handlers) do
      [
        {topic: 'orders/create', handler: double('create handler 1 of 1')},
        {topic: 'orders/update', handler: double('update handler 1 of 2')},
        {topic: 'orders/update', handler: double('update handler 2 of 2')},
      ]
    end

    let(:webhook) do
      Webhook.new(
        'example.myshopify.com',
        'orders/update',
        '{}'
      )
    end

    subject(:webhook_handler_list) { WebhookHandlerList.new }

    before do
      handlers.each { |h| webhook_handler_list.register(h[:topic], h[:handler]) }
    end

    it 'registers handlers' do
      expect(webhook_handler_list['orders/create']).to contain_exactly(
        handlers[0][:handler]
      )
      expect(webhook_handler_list['orders/update']).to contain_exactly(
        handlers[1][:handler],
        handlers[2][:handler]
      )
    end

    it 'registers block handlers' do
      # TODO
    end

    it 'delegates to topic handlers' do
      handlers.reject { |h| h[:topic] == webhook.topic }.each do |handler|
        expect(handler[:handler]).not_to receive(:call)
      end
      handlers.select { |h| h[:topic] == webhook.topic }.each do |handler|
        expect(handler[:handler]).to receive(:call).with(webhook)
      end

      webhook_handler_list.delegate(webhook)
    end
  end
end
