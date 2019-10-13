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

Lucid::Shopify.configure(
  api_key: 'fake',
  api_version: 'fake',
  billing_callback_uri: 'fake',
  callback_uri: 'fake',
  scope: 'fake',
  shared_secret: 'fake',
  webhook_uri: 'fake',
)
