# frozen_string_literal: true

module Minutely
  class TimeRange
    ##
    # A parser that tries to convert the input value to `Minutely::TimeRange`.
    class Parser < Minutely::Parser
      def parse
        case value
        when nil then nil
        when Array then parse_array(value)
        when Hash then parse_hash
        when String then parse_string
        when TimeRange then value
        else raise ArgumentError, 'invalid time range'
        end
      end

      private

      def parse_array(items)
        if items.length != 2 || include_empty_item?(items)
          raise ArgumentError, 'invalid time range'
        end

        TimeRange.new(*items)
      end

      def parse_hash
        return nil if value.empty?

        parse_array(value.fetch_values(:from, :to))
      end

      def parse_string
        return nil if value.empty?

        items = value.split('-').map(&:strip)
        parse_array(items)
      end

      def include_empty_item?(items)
        items.any? do |item|
          item.nil? || (item.respond_to?(:empty?) && item.empty?)
        end
      end
    end
  end
end
