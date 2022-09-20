# frozen_string_literal: true

module Trifle
  module Logs
    module Operations
      class Dump
        attr_reader :namespace, :payload, :scope

        def initialize(**keywords)
          @namespace = keywords.fetch(:namespace)
          @payload = keywords.fetch(:payload)
          @scope = keywords.fetch(:scope)
          @config = keywords[:config]
        end

        def config
          @config || Trifle::Logs.default
        end

        def formatted
          [
            config.timestamp_formatter.format(Time.now),
            config.content_formatter.format(scope, payload)
          ].join(' ')
        end

        def perform
          config.driver.dump(
            formatted, namespace: namespace
          )
        end
      end
    end
  end
end
