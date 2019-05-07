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

require 'lucid_shopify'

LucidShopify.config = LucidShopify::Config.new(
  'fake',
  'fake',
  'fake',
  'fake',
  'fake',
  'fake',
  'fake',
)
