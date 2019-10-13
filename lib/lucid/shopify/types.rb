# frozen_string_literal: true

module Lucid
  module Shopify
    module Types
      include Dry.Types(default: :strict)

      Logger = Instance(Logger)
    end
  end
end
