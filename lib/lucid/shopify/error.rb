# frozen_string_literal: true

module Lucid
  module Shopify
    # Subclass this class for all gem exceptions, so that callers may rescue
    # any subclass with:
    #
    #     rescue Lucid::Shopify::Error => e
    Error = Class.new(StandardError)
  end
end
