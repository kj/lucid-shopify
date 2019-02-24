# frozen_string_literal: true

$LOAD_PATH.unshift "#{__dir__}/lib"

require 'lucid_shopify/version'

Gem::Specification.new do |s|
  s.add_development_dependency 'dotenv', '~> 2.2'
  s.add_development_dependency 'rake', '~> 12.3'
  s.add_development_dependency 'rspec', '~> 3.6'
  s.add_development_dependency 'rubocop', '0.58.2'
  s.add_runtime_dependency 'dry-container', '~> 0.6'
  s.add_runtime_dependency 'dry-initializer', '~> 2.4'
  s.add_runtime_dependency 'http', '~> 3.0'
  s.author = 'Kelsey Judson'
  s.email = 'kelsey@lucid.nz'
  s.files = Dir.glob('lib/**/*') + %w[README.md]
  s.homepage = 'https://github.com/lucidnz/gem-lucid_shopify'
  s.license = 'ISC'
  s.name = 'lucid_shopify'
  s.summary = 'Shopify client library'
  s.version = LucidShopify::VERSION
end
