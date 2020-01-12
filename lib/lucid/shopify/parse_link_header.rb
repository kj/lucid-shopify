# frozen_string_literal: true

require 'lucid/shopify'

module Lucid
  module Shopify
    class ParseLinkHeader
      # Parse a Link header into query params for each pagination link (e.g.
      # :next, :previous).
      #
      # @param link_header [String, nil]
      #
      # @return [Hash]
      def call(link_header)
        return {} if link_header.nil?

        link_header.split(',').map do |link|
          url, rel = link.split(';') # rel should be the first param
          url = url[/<(.*)>/, 1]
          rel = rel[/rel="?(\w+)"?/, 1]

          [rel.to_sym, query_params(url)]
        end.to_h
      end

      # @param url [String]
      #
      # @return [Hash]
      private def query_params(url)
        url.split('?').last.split('&').map do |param|
          name, value = param.split('=')
          name == 'limit' && value = value.to_i

          [name.to_sym, value]
        end.to_h
      end
    end
  end
end
