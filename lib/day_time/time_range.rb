# frozen_string_literal: true

module DayTime
  ##
  # A class that represents a range of day times that is only using hours
  # and minutes.
  #
  # @!attribute [r] from
  #   @return [MinuteTimeRange]
  #
  # @!attribute [r] to
  #   @return [MinuteTimeRange]
  class TimeRange
    include Comparable

    attr_reader :from, :to

    ##
    # Builds a new `MinuteTimeRange`.
    #
    # @param from [MinuteTimeRange, String, Fixnum]
    #
    # @param to [MinuteTimeRange, String, Fixnum]
    #
    # @raise [ArgumentError] when first or second argument evaluates to `nil`.
    def initialize(from, to)
      @from = DayTime::Time.parse(from)
      @to = DayTime::Time.parse(to)

      raise ArgumentError, 'invalid time range' if @from.nil? || @to.nil?
    end

    class << self
      ##
      # Parses the given input and returns a `MinuteTimeRange` or `nil`,
      # respectively.
      #
      # @param obj [MinuteTimeRange, Array, Hash, String, nil]
      #
      # @return [MinuteTimeRange, nil]
      #
      # @raise [ArgumentError] when the object does not represent a valid time
      #   range
      #
      # @raise [KeyError] when the given Hash does not contain the required keys
      # (`:from` and `:to`)
      def parse(obj)
        case obj
        when nil then nil
        when self then obj
        when Array then parse_array(obj)
        when Hash then parse_hash(obj)
        when String then parse_string(obj)
        else raise ArgumentError, 'invalid time range'
        end
      end

      private

      def parse_array(items)
        if items.length != 2 || items.any?(&:blank?)
          raise ArgumentError, 'invalid time range'
        end

        new(*items)
      end

      def parse_hash(hash)
        return nil if hash.empty?

        parse_array(hash.fetch_values(:from, :to))
      end

      def parse_string(str)
        return nil if str.empty?

        items = str.split('-').map(&:strip)
        parse_array(items)
      end
    end

    def <=>(other)
      return nil unless other.is_a?(self.class)

      [from, to] <=> [other.from, other.to]
    end

    def to_a
      [from, to].map(&:to_i)
    end

    def to_s
      [from, to].join('-')
    end

    alias as_json to_s
  end
end