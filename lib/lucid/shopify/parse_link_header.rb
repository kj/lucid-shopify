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
        case link_header
        # NOTE: There is a strange behaviour where it seems that if the header
        # value exceeds a certain length, it is split into chunks. It seems that
        # if you use {HTTP::Headers#get}, you will always get {Array<String},
        # and it is the special behaviour of {HTTP::Headers#[]} causing this.
        #
        # However, why is it split in the first place? Does Shopify send
        # multiple Link headers (as chunks) for longer values? There does not
        # seem to be any limit on the length of value in the HTTP specification.
        #
        # https://www.rubydoc.info/gems/http/HTTP/Headers#[]-instance_method
        # https://www.rubydoc.info/gems/http/HTTP/Headers#get-instance_method
        when Array
          link_header = link_header.join
        when String
        else
          return {}
        end

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
