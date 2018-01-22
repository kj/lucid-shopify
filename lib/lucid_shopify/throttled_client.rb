# frozen_string_literal: true

require 'date'
require 'lucid_shopify/authorized_client'

module LucidShopify
  #
  # A throttled interface to the Shopify API, authorized for a given shop.
  #
  class ThrottledClient < AuthorizedClient
    MINIMUM_INTERVAL = 500 # ms

    #
    # @return [ThrottledClient]
    #
    def throttled
      self
    end

    #
    # @return [AuthorizedClient]
    #
    def unthrottled
      @authorized_client ||= AuthorizedClient.new(shop)
    end

    private def request(*)
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
      '%s[%d].timestamp' % [self.class, shop.id]
    end

    #
    # Time in milliseconds since the UNIX epoch.
    #
    # @return [Integer]
    #
    private def timestamp
      DateTime.now.strftime('%Q').to_i
    end
  end
end
