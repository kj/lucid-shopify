$: << "#{__dir__}/lib"

require 'lucid_shopify/version'

task default: :build

task :build do
  system 'gem build lucid_shopify.gemspec'
end

task install: :build do
  system "gem install lucid_shopify-#{LucidShopify::VERSION}.gem"
end

task :clean do
  system 'rm lucid_shopify-*.gem'
end
