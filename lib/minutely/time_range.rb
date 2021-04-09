# frozen_string_literal: true

module Minutely
  ##
  # A class that represents a range of day times that is only using hours
  # and minutes.
  #
  # @!attribute [r] from
  #   @return [Minutely::Time]
  #
  # @!attribute [r] to
  #   @return [Minutely::Time]
  class TimeRange
    autoload :Parser, 'minutely/time_range/parser'

    include Comparable
    include Enumerable
    include StringAsJson

    attr_reader :from, :to

    ##
    # Builds a new `Minutely::TimeRange`.
    #
    # @param from [Minutely::Time, String, Integer]
    #
    # @param to [Minutely::Time, String, Integer]
    #
    # @raise [ArgumentError] when first or second argument evaluates to `nil`.
    def initialize(from, to, exclude_end: false)
      @from = Minutely::Time.parse(from)
      @to = Minutely::Time.parse(to)

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

    ##
    # Parses the given input and returns a `Minutely::TimeRange` or `nil`,
    # respectively.
    #
    # @param value [Minutely::TimeRange, Array, Hash, String, nil]
    #
    # @return [Minutely::TimeRange, nil]
    #
    # @raise [ArgumentError] when the object does not represent a valid time
    #   range
    #
    # @raise [KeyError] when the given Hash does not contain the required keys
    # (`:from` and `:to`)
    def self.parse(value)
      TimeRange::Parser.new(value).parse
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
      time = Minutely::Time.parse(time)
      end_predicate = exclude_end? ? time < to : time <= to
      from <= time && end_predicate
    end

    ##
    # Iterates over all range elements and calls the given block for each
    # element or returns a lazy enumerator when called without block.
    #
    # @yield [time] A block called for every range element.
    #
    # @yieldparam time [Minutely::Time] The range element.
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
