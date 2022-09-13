# frozen_string_literal: true

module Trifle
  module Logs
    class Result
      attr_reader :min_loc, :max_loc

      def initialize(lines = [], min_loc: nil, max_loc: nil)
        @lines = lines
        @min_loc = min_loc
        @max_loc = max_loc
      end

      def meta
        @lines.last || {}
      end

      def data
        meta.dig('data', 'stats', 'matches').to_i.positive? ? @lines[1..-3] : []
      end
    end
  end
end
