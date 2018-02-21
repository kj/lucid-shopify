# frozen_string_literal: true

module LucidShopify
  class Result
    #
    # @param value [Object]
    # @param error [Object]
    #
    def initialize(value, error = nil)
      @value = value
      @error = error
    end

    # @return [Object] 
    attr_reader :value
    # @return [Object] 
    attr_reader :error

    #
    # @return [Boolean]
    #
    def success?
      error.nil?
    end

    #
    # @return [Boolean]
    #
    def failure?
      !success?
    end
  end
end
