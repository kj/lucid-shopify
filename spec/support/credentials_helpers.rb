# frozen_string_literal: true

require 'lucid_shopify/credentials'

module CredentialsHelpers
  def credentials
    @credentials ||=
      LucidShopify::Credentials.new(myshopify_domain)
  end

  def credentials_authenticated
    @credentials_authenticated ||=
      LucidShopify::Credentials.new(myshopify_domain, access_token)
  end

  #
  # For integration specs, set SHOPIFY_MYSHOPIFY_DOMAIN to a dev shop.
  #
  def myshopify_domain
    ENV.fetch('SHOPIFY_MYSHOPIFY_DOMAIN', 'example.myshopify.com')
  end

  #
  # For integration specs, set SHOPIFY_ACCESS_TOKEN to a private app password.
  #
  def access_token
    ENV.fetch('SHOPIFY_PASSWORD', 'access_token')
  end
end
