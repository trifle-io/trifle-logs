# frozen_string_literal: true

module Trifle
  module Logs
    class Configuration
      attr_writer :driver
      attr_accessor :timestamp_formatter, :content_formatter

      def initialize; end

      def driver
        raise DriverNotFound if @driver.nil?

        @driver
      end
    end
  end
end

# c = Trifle::Logs::Configuration.new.tap do |c|
#   c.driver = Trifle::Logs::Driver::File.new(path: 'test')
#   c.timestamp_formatter = Trifle::Logs::Formatter::Timestamp.new
#   c.content_formatter = Trifle::Logs::Formatter::Content::Json.new
# end
