# frozen_string_literal: true

$LOAD_PATH.unshift(__dir__ + '/../lib')

require_relative 'support/credentials_helpers'
require_relative 'support/fixture_helpers'
require_relative 'support/matchers'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.expose_dsl_globally = false
  config.filter_gems_from_backtrace 'dry-container', 'dry-initializer', 'http'
  config.include(CredentialsHelpers)
  config.include(FixtureHelpers)
  # config.order = :random # TODO: use order: :defined metadata for specific specs
end

require 'lucid-shopify'

Lucid::Shopify.configure do |config|
  config.api_key = 'fake'
  config.billing_callback_uri = 'fake'
  config.callback_uri = 'fake'
  config.scope = 'fake'
  config.shared_secret = 'fake'
  config.webhook_uri = 'fake'
end
