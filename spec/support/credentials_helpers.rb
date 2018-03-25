# frozen_string_literal: true

require 'yaml'

require 'lucid_shopify/request_credentials'

module CredentialsHelpers
  def self.included(base)
    base.let(:myshopify_domain) { 'example.myshopify.com' }
    base.let(:access_token) { 'example_access_token' }
    base.let(:credentials) { LucidShopify::RequestCredentials.new(myshopify_domain) }
    base.let(:credentials_authenticated) { LucidShopify::RequestCredentials.new(myshopify_domain, access_token) }
  end
end
