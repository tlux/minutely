# frozen_string_literal: true

module DayTime
  ##
  # A class that represents a range of day times that is only using hours
  # and minutes.
  #
  # @!attribute [r] from
  #   @return [DayTime::Time]
  #
  # @!attribute [r] to
  #   @return [DayTime::Time]
  class TimeRange
    include Comparable
    include Enumerable
    include StringAsJson

    attr_reader :from, :to

    ##
    # Builds a new `DayTime::TimeRange`.
    #
    # @param from [DayTime::Time, String, Fixnum]
    #
    # @param to [DayTime::Time, String, Fixnum]
    #
    # @raise [ArgumentError] when first or second argument evaluates to `nil`.
    def initialize(from, to, exclude_end: false)
      @from = DayTime::Time.parse(from)
      @to = DayTime::Time.parse(to)

      raise ArgumentError, 'invalid time range' if @from.nil? || @to.nil?

      @exclude_end = exclude_end
    end

    ##
    # Indicates whether the range excludes the last item.
    #
    # @return [Boolean]
    def exclude_end?
      @exclude_end
    end

    class << self
      ##
      # Parses the given input and returns a `DayTime::TimeRange` or `nil`,
      # respectively.
      #
      # @param obj [DayTime::TimeRange, Array, Hash, String, nil]
      #
      # @return [DayTime::TimeRange, nil]
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
        if items.length != 2 || items.any? { |item| Utils.blank?(item) }
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

    ##
    # Compares the time range to another one.
    #
    # @return [Integer]
    def <=>(other)
      return nil unless other.is_a?(self.class)
      return nil if exclude_end? != other.exclude_end?

      [from, to] <=> [other.from, other.to]
    end

    ##
    # Determines whether the specified time is in the range.
    #
    # @return [Boolean]
    def include?(time)
      time = DayTime::Time.parse(time)
      end_predicate = exclude_end? ? time < to : time <= to
      from <= time && end_predicate
    end

    ##
    # Iterates over all range elements and calls the given block for each
    # element or returns a lazy enumerator when called without block.
    #
    # @yield [time] A block called for every range element.
    #
    # @yieldparam time [DayTime::Time] The range element.
    #
    # @return [Enumerator, void]
    def each
      return to_enum(:each) unless block_given?

      val = from

      loop do
        yield(val) if !exclude_end? || val != to
        break if val == to

        val = val.succ
      end
    end

    ##
    # Indicates whether the range spans midnight.
    #
    # @return [Boolean]
    def spanning_midnight?
      from > to
    end

    ##
    # Converts the time range into a Range. This does only work when the range
    # spans midnight due to the way Ranges are based on value comparison.
    #
    # @raise [RuntimeError] when the time range spans midnight.
    # @return [Range]
    def to_r
      raise 'Unable to convert ranges spanning midnight' if spanning_midnight?

      return from...to if exclude_end?

      from..to
    end

    ##
    # Converts the time range into a string.
    #
    # @return [String]
    def to_s
      [from, to].join('-')
    end
  end
end
