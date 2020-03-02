# frozen_string_literal: true

require 'lucid/shopify/client'

module Lucid
  module Shopify
    RSpec.describe BulkRequest do
      let(:client) { Client.new }
      let(:credentials) { credentials_authenticated }

      before(:all) do
        Shopify.config.logger = Logger.new(STDOUT)
      end

      after(:all) do
        Shopify.config.logger = Logger.new(File::NULL)
      end

      it 'yields each line of the result' do
        expect do |b|
          client.bulk(credentials).(<<~QUERY) do |product|
            {
              products {
                edges {
                  node {
                    id
                    title
                  }
                }
              }
            }
          QUERY
            b.to_proc.(product)
            expect(product).to include('id' => String)
            expect(product).to include('title' => String)
          end
        end.to yield_control
      end

      # TODO: Test Operation#around.
    end
  end
end
