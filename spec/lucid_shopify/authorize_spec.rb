# frozen_string_literal: true

module LucidShopify
  RSpec.describe Authorise do
    let(:post_data) { oauth_api['post data'] }
    let(:client) { instance_double('Client') }

    subject(:authorise) do
      Authorise.new(
        client: client
      )
    end

    include_fixtures 'oauth_api.yml.erb'

    before do
      expect(client).to receive(:post_json) do |*args|
        expect(args[0]).to be_a(Credentials).and have_attributes(
          myshopify_domain: credentials.myshopify_domain
        )
        expect(args[1]).to eq('oauth/access_token')
        expect(args[2]).to eq(post_data)

        data
      end
    end

    context 'when okay' do
      let(:data) { oauth_api['okay'] }

      it 'fetches access token' do
        access_token = authorise.(credentials.myshopify_domain, post_data[:code])

        expect(access_token).to eq(data['access_token'])
      end
    end

    shared_examples 'fail' do
      it 'raises an error' do
        call = -> { authorise.(credentials.myshopify_domain, post_data[:code]) }

        expect(&call).to raise_error(Authorise::Error)
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
