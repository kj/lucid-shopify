# frozen_string_literal: true

require 'lucid_shopify/send_request'

%w(delete get post put).each { |m| require "lucid_shopify/#{m}_request" }

module LucidShopify
  RSpec.describe SendRequest do
    subject(:send_request) { SendRequest.new }

    context 'requesting shop data' do
      let(:request) { GetRequest.new(credentials_authenticated, 'shop') }

      it 'returns data' do
        data = send_request.(request)['shop']

        expect(data).to include('id')
      end
    end
  end
end
