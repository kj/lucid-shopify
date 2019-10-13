# frozen_string_literal: true

require 'lucid/shopify/send_request'

%w[delete get post put].each { |m| require "lucid/shopify/#{m}_request" }

module Lucid
  module Shopify
    RSpec.describe SendRequest do
      subject(:send_request) { SendRequest.new }

      context 'requesting shop data' do
        let(:request) { GetRequest.new(credentials_authenticated, 'shop') }

        it 'returns data' do
          data = send_request.(request)['shop']

          expect(data).to include('id')
        end
      end

      # TODO: 1. POST (create) something; test existence
      # TODO: 2. PUT (update) something; test changed
      # TODO: 3. DELETE something; test lack of existence
    end
  end
end
