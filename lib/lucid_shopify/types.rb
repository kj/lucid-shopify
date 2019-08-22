# frozen_string_literal: true

module LucidShopify
  module Types
    include Dry.Types(default: :strict)

    Logger = Instance(Logger)
  end
end
