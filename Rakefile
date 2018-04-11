# frozen_string_literal: true

task :lint do
  system 'bundle exec rubocop'
end

task :test do
  system 'bundle exec rspec -r./spec/spec_helper spec/lucid_shopify'
end

task :test_integration do
  system 'bundle exec rspec -r./spec/spec_helper spec/integration/lucid_shopify'
end

task default: :test
