# frozen_string_literal: true

require 'lucid_shopify'

if defined?(Redis)
  module LucidShopify
    class RedisThrottledStrategy < ThrottledStrategy
    end
  end
end
