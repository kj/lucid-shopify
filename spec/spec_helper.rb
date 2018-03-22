# frozen_string_literal: true

$LOAD_PATH << __dir__ + '/../lib'

require_relative 'support/fixture_helpers'

RSpec.configure do |config|
  config.expose_dsl_globally = false
  config.include(FixtureHelpers)
end

require 'lucid_shopify/config'

LucidShopify.config = LucidShopify::Config.new(
  'fake',
  'fake',
  'fake',
  'fake',
  'fake'
)
