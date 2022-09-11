# frozen_string_literal: true

module Trifle
  module Logs
    module Formatter
      module Content
        class Text
          def format(query, message)
            [
              query.map { |pair| pair.join(':') }.join(';'),
              message
            ].join(' ')
          end
        end
      end
    end
  end
end
