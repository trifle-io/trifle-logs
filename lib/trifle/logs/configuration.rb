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
