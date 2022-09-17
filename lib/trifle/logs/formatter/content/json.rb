# frozen_string_literal: true

require 'json'

module Trifle
  module Logs
    module Formatter
      module Content
        class Json
          def format(scope, message)
            {
              scope: scope,
              content: message
            }.to_json
          end
        end
      end
    end
  end
end
