# frozen_string_literal: true

require 'lucid_shopify'

module LucidShopify
  #
  # Maintain API call limit throttling across a single thread.
  #
  class ThrottledStrategy
    MINIMUM_INTERVAL = 500 # ms

    #
    # @param request [Request]
    #
    # @yieldreturn [Response]
    #
    # @return [Response]
    #
    def call(request, &send_request)
      interval(build_interval_key(request))

      send_request.()
    end

    #
    # If time since the last request < {MINIMUM_INTERVAL}, then sleep for the
    # difference.
    #
    # @param interval_key [String]
    #
    private def interval(interval_key)
      if Thread.current[interval_key]
        (timestamp - Thread.current[interval_key]).tap do |n|
          sleep(Rational(MINIMUM_INTERVAL - n, 1000)) if n < MINIMUM_INTERVAL
        end
      end

      Thread.current[interval_key] = timestamp
    end

    #
    # @param request [Request]
    #
    # @return [String]
    #
    private def build_interval_key(request)
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
