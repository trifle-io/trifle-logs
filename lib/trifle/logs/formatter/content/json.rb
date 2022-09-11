# frozen_string_literal: true

require 'json'

module Trifle
  module Logs
    module Formatter
      module Content
        class Json
          def format(query, message)
            {
              query: query,
              content: message
            }.to_json
          end
        end
      end
    end
  end
end
