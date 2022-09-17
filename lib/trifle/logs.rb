# frozen_string_literal: true

require_relative 'logs/version'
require_relative 'logs/configuration'
require_relative 'logs/result'
require_relative 'logs/driver/file'
require_relative 'logs/operations/dump'
require_relative 'logs/operations/searcher'
require_relative 'logs/formatter/timestamp'
require_relative 'logs/formatter/content/text'
require_relative 'logs/formatter/content/json'

module Trifle
  module Logs
    class Error < StandardError; end
    class DriverNotFound < Error; end

    def self.default
      @default ||= Configuration.new
    end

    def self.configure
      yield(default)

      default
    end

    def self.dump(namespace, payload, scope: {}, config: nil)
      Trifle::Logs::Operations::Dump.new(
        namespace: namespace,
        payload: payload,
        scope: scope,
        config: config
      ).perform
    end

    def self.searcher(namespace, pattern: nil, config: nil, min_loc: nil, max_loc: nil)
      Trifle::Logs::Operations::Searcher.new(
        namespace: namespace,
        pattern: pattern,
        config: config,
        min_loc: min_loc,
        max_loc: max_loc
      )
    end
  end
end
