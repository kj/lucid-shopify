# frozen_string_literal: true

require 'yaml'

module FixtureHelpers
  class << self
    def included(base)
      base.extend(ClassMethods)
    end

    def cache
      @cache ||= Hash.new do |h, path|
        raw_data = File.read("#{__dir__}/../fixtures/#{path}")

        h[path] = path.split('.')[1..-1].reverse.reduce(raw_data) do |data, ext|
          case ext
          when 'erb' then ERB.new(data).result
          when 'yml' then YAML.safe_load(data)
          else
            data
          end
        end
      end
    end
  end

  #
  # @param path [String] relative to /spec/fixtures
  #
  # @return [String, Hash] {Hash} if *.yml
  #
  def fixture(path)
    FixtureHelpers.cache[path]
  end

  module ClassMethods
    def include_fixtures(*paths)
      paths.each do |path|
        define_method(path.split('.').first) do
          fixture(path)
        end
      end
    end
  end
end
