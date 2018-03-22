# frozen_string_literal: true

module LucidShopify
  #
  # Subclass this class for all gem exceptions, so that callers may r escue
  # any subclass with:
  #
  #     rescue LucidShopify::Error => e
  #
  Error = Class.new(StandardError)
end
