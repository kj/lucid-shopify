# frozen_string_literal: true

require 'lucid_shopify'

if defined?(Redis)
  module LucidShopify
    #
    # Use Redis to maintain API call limit throttling across threads/processes.
    #
    # No delay for requests up to half of the call limit.
    #
    class RedisThrottledStrategy < ThrottledStrategy
      LEAK_RATE = 500

      #
      # @param redis_client [Redis]
      #
      def initialize(redis_client: Redis.current)
        @redis_client = redis_client
      end

      #
      # @param request [Request]
      #
      # @yieldreturn [Response]
      #
      # @return [Response]
      #
      def call(request, &send_request)
        interval_key = build_interval_key(request)

        interval(interval_key)

        send_request.().tap do |res|
          header = res.headers['X-Shopify-Shop-Api-Call-Limit']

          next if header.nil?

          cur, max = header.split('/')

          @redis_client.mapped_hmset(interval_key,
            cur: cur,
            max: max,
            at: timestamp
          )
        end
      end

      #
      # If over half the call limit, sleep until requests leak back to the
      # threshold.
      #
      # @param interval_key [String]
      #
      private def interval(interval_key)
        cur, max, at = @redis_client.hmget(interval_key, :cur, :max, :at).map(&:to_i)

        cur = leak(cur, at)

        delay_threshold = max / 2 # no delay

        if cur > delay_threshold
          sleep(Rational((cur - delay_threshold) * LEAK_RATE, 1000))
        end
      end

      #
      # Find the actual value of {cur}, by subtracting requests leaked by the
      # leaky bucket algorithm since the value was set.
      #
      # @param cur [Integer]
      # @param at [Integer]
      #
      # @return [Integer]
      #
      private def leak(cur, at)
        n = Rational(timestamp - at, LEAK_RATE).floor

        n > cur ? 0 : cur - n
      end
    end
  end
end
