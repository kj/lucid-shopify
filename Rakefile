# frozen_string_literal: true

task :lint do
  system 'bundle exec rubocop'
end

task :test_integration do
  require 'dotenv'

  Dotenv.load

  missing_env = %w(
    SHOPIFY_MYSHOPIFY_DOMAIN
    SHOPIFY_PASSWORD
  ).select do |var|
    next if ENV[var]

    puts "Missing environment variable #{var}"

    true
  end

  exit 1 if missing_env.any?

  system 'bundle exec rspec -r./spec/spec_helper spec/integration/lucid_shopify'
end

task :test do
  system 'bundle exec rspec -r./spec/spec_helper spec/lucid_shopify_spec.rb spec/lucid_shopify'
end

task default: :test
