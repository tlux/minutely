module Minutely
  class TimeRange
    class Parser < Minutely::Parser
      def parse
        case value
        when nil then nil
        when TimeRange then value
        when Array then parse_array(value)
        when Hash then parse_hash
        when String then parse_string
        else raise ArgumentError, 'invalid time range'
        end
      end

      private

      def parse_array(items)
        if items.length != 2 || items.any? { |item| Utils.blank?(item) }
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
    end
  end
end
