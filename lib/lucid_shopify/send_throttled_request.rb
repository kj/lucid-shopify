# frozen_string_literal: true

require 'lucid_shopify/send_request'

module LucidShopify
  class SendThrottledRequest < SendRequest
    MINIMUM_INTERVAL = 500 # ms

    #
    # @see {SendRequest#call}
    #
    private def call(*)
      interval

      super
    end

    #
    # Sleep for the difference if time since the last request is less than the
    # MINIMUM_INTERVAL.
    #
    # @note Throttling is only maintained across a single thread.
    #
    private def interval
      if Thread.current[interval_key]
        (timestamp - Thread.current[interval_key]).tap do |n|
          sleep(Rational(n, 1000)) if n < MINIMUM_INTERVAL
        end
      end

      Thread.current[interval_key] = timestamp
    end

    #
    # @return [String]
    #
    private def interval_key
      '%s[%s].timestamp' % [self.class, request.credentials.myshopify_domain]
    end

    #
    # Time in milliseconds since the UNIX epoch.
    #
    # @return [Integer]
    #
    private def timestamp
      (Time.now.to_f * 1000).to_i
    end
  end
end
