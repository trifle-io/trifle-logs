# frozen_string_literal: true

module Trifle
  module Logs
    module Formatter
      class Timestamp
        def format(timestamp)
          timestamp.strftime('%Y-%m-%dT%H:%M:%S.%6N')
        end
      end
    end
  end
end
