# frozen_string_literal: true

require 'lucid_shopify/fetch_access_token'

module LucidShopify
  RSpec.describe FetchAccessToken do
    let(:post_data) { oauth_api['post data'] }
    let(:client) { instance_double('Client') }

    subject(:fetch_access_token) do
      FetchAccessToken.new(
        client: client
      )
    end

    include_fixtures 'oauth_api.yml.erb'

    before do
      expect(client).to receive(:post_json) do |*args|
        expect(args[0]).to be(credentials)
        expect(args[1]).to eq('oauth/access_token')
        expect(args[2]).to eq(post_data)

        data
      end
    end

    context 'when okay' do
      let(:data) { oauth_api['okay'] }

      it 'fetches access token' do
        access_token = fetch_access_token.(credentials, post_data[:code])

        expect(access_token).to eq(data['access_token'])
      end
    end

    shared_examples 'fail' do
      it 'raises an error' do
        call = proc { fetch_access_token.(credentials, post_data[:code]) }

        expect(&call).to raise_error(FetchAccessToken::Error)
      end
    end

    context 'when fail with no access token' do
      let(:data) { oauth_api['fail with no access token'] }

      include_examples 'fail'
    end

    context 'when fail with wrong scope' do
      let(:data) { oauth_api['fail with wrong scope'] }

      include_examples 'fail'
    end
  end
end
