module Minutely
  class Time
    class Parser < Minutely::Parser
      def parse
        return nil if Utils.blank?(value)
        return value if value.is_a?(Time)

        if value.respond_to?(:hour) && value.respond_to?(:min)
          return Time.new(value.hour, value.min)
        end

        case value
        when Integer then parse_integer
        when String then parse_string
        else raise ArgumentError, 'invalid time'
        end
      end

      private

      def parse_integer
        hour = value / 100
        minute = value % 100
        Time.new(hour, minute)
      end

      def parse_string
        matches = value.match(/\A(?<hour>\d{1,2}):(?<minute>\d{2})\z/)
        raise ArgumentError, 'invalid time string' unless matches

        Time.new(matches[:hour].to_i, matches[:minute].to_i)
      end
    end
  end
end
