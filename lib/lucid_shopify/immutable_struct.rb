# frozen_string_literal: true

module LucidShopify
  class ImmutableStruct < Struct
    def initialize(*)
      super

      post_initialize

      freeze
    end

    #
    # @abstract
    #
    def post_initialize; end
  end
end
