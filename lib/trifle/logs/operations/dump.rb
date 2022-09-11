# frozen_string_literal: true

module Trifle
  module Logs
    module Operations
      class Dump
        attr_reader :namespace, :payload, :query

        def initialize(**keywords)
          @namespace = keywords.fetch(:namespace)
          @payload = keywords.fetch(:payload)
          @query = keywords.fetch(:query)
          @config = keywords[:config]
        end

        def config
          @config || Trifle::Logs.default
        end

        def formatted
          [
            config.timestamp_formatter.format(Time.now),
            config.content_formatter.format(query, payload)
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
