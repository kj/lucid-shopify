# frozen_string_literal: true

$LOAD_PATH.unshift "#{__dir__}/lib"

require 'lucid_shopify/version'

Gem::Specification.new do |s|
  s.add_development_dependency 'dotenv', '~> 2.7'
  s.add_development_dependency 'rake', '~> 12.3'
  s.add_development_dependency 'rspec', '~> 3.8'
  s.add_development_dependency 'rubocop', '0.67'
  s.add_runtime_dependency 'dry-container', '~> 0.7'
  s.add_runtime_dependency 'dry-initializer', '~> 3.0'
  s.add_runtime_dependency 'dry-struct', '~> 1.0'
  s.add_runtime_dependency 'http', '~> 4.1'
  s.author = 'Kelsey Judson'
  s.email = 'kelsey@lucid.nz'
  s.files = Dir.glob('lib/**/*') + %w[README.md]
  s.homepage = 'https://github.com/lucidnz/gem-lucid_shopify'
  s.license = 'ISC'
  s.name = 'lucid_shopify'
  s.summary = 'Shopify client library'
  s.version = LucidShopify::VERSION
end
