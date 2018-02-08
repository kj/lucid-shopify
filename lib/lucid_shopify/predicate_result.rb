# frozen_string_literal: true

module LucidShopify
  class PredicateResult
    #
    # @param result [Boolean]
    #
    def initialize(result)
      @result = result
    end

    #
    # @return Boolean
    #
    def success?
      @result
    end
  end
end
