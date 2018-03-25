# frozen_string_literal: true

require 'yaml'

require 'lucid_shopify/request_credentials'

module CredentialsHelpers
  def self.included(base)
    base.let(:myshopify_domain) { 'example.myshopify.com' }
    base.let(:access_token) { 'example_access_token' }
    base.let(:credentials) { credentials_unauthenticated }
    base.let(:credentials_authenticated) { LucidShopify::RequestCredentials.new(myshopify_domain, access_token) }
    base.let(:credentials_unauthenticated) { LucidShopify::RequestCredentials.new(myshopify_domain) }
  end
end
