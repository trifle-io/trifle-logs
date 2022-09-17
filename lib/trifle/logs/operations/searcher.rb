# frozen_string_literal: true

module Trifle
  module Logs
    module Operations
      class Searcher
        attr_reader :namespace, :pattern, :min_loc, :max_loc

        def initialize(**keywords)
          @namespace = keywords.fetch(:namespace)
          @pattern = keywords.fetch(:pattern)
          @config = keywords[:config]
          @min_loc = keywords[:min_loc]
          @max_loc = keywords[:max_loc]
        end

        def config
          @config || Trifle::Logs.default
        end

        def perform
          result = config.driver.search(
            namespace: namespace, pattern: pattern
          )
          @min_loc = result.min_loc
          @max_loc = result.max_loc
          result
        end

        def prev
          return Trifle::Logs::Result.new if @min_loc.nil?

          result = config.driver.search(
            namespace: namespace, pattern: pattern,
            file_loc: @min_loc, direction: :prev
          )

          @min_loc = result.min_loc
          result
        end

        def next
          return Trifle::Logs::Result.new if @max_loc.nil?

          result = config.driver.search(
            namespace: namespace, pattern: pattern,
            file_loc: @max_loc, direction: :next
          )

          @max_loc = result.max_loc
          result
        end
      end
    end
  end
end
