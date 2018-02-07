# frozen_string_literal: true

$LOAD_PATH << "#{__dir__}/lib"

require 'lucid_shopify/version'

task(default: :build)
task(:build) { system 'gem build lucid_shopify.gemspec' }
task(install: :build) { system "gem install lucid_shopify-#{LucidShopify::VERSION}.gem" }
task(:clean) { system 'rm lucid_shopify-*.gem' }
