# frozen_string_literal: true

module DayTime
  ##
  # A class that represents a day time by using only hours and minutes.
  #
  # @!attribute [r] hour
  #   @return [Integer]
  #
  # @!attribute [r] minute
  #   @return [Integer]
  class Time
    include Comparable
    include StringAsJson

    attr_reader :hour, :minute
    alias min minute

    ##
    # Builds a new `DayTime::Time`.
    #
    # @param hour [Integer] a number between 0 and 23
    #
    # @param minute [Integer] a number between 0 and 59
    #
    # @raise [ArgumentError] when arguments are not within the specified ranges
    def initialize(hour, minute)
      raise ArgumentError, 'invalid hour' unless (0..24).include?(hour)
      raise ArgumentError, 'invalid minute' unless (0..59).include?(minute)

      @hour = hour == 24 ? 0 : hour
      @minute = minute
    end

    ##
    # Returns the begining of day.
    #
    # @return [DayTime::Time]
    def self.beginning_of_day
      new(0, 0)
    end

    ##
    # Returns the end of day.
    #
    # @return [DayTime::Time]
    def self.end_of_day
      new(23, 59)
    end

    ##
    # Parses the given input and returns a `DayTime::Time` or `nil`,
    # respectively.
    #
    # @param obj [DayTime::Time, #hour, #min, Integer, String, nil]
    #
    # @return [DayTime::Time, nil]
    #
    # @raise [ArgumentError] when the object does not represent a valid time
    def self.parse(obj)
      return nil if Utils.blank?(obj)
      return obj if obj.is_a?(self)

      if obj.respond_to?(:hour) && obj.respond_to?(:min)
        return new(obj.hour, obj.min)
      end

      case obj
      when Integer then parse_integer(obj)
      when String then parse_string(obj)
      else raise ArgumentError, 'invalid time'
      end
    end

    def self.parse_integer(value)
      hour = value / 100
      minute = value % 100
      new(hour, minute)
    end

    def self.parse_string(str)
      matches = str.match(/\A(?<hour>\d{1,2}):(?<minute>\d{2})\z/)
      raise ArgumentError, 'invalid time string' unless matches

      new(matches[:hour].to_i, matches[:minute].to_i)
    end

    private_class_method :parse_integer, :parse_string

    ##
    # Compares the time to another one.
    #
    # @return [Integer]
    def <=>(other)
      return nil unless other.is_a?(self.class)

      [hour, minute] <=> [other.hour, other.minute]
    end

    ##
    # Gets the next minute as new `DayTime::Time`.
    #
    # @return [DayTime::Time]
    def succ
      return self.class.new((hour + 1) % 24, 0) if minute == 59

      self.class.new(hour, minute + 1)
    end

    ##
    # Converts the time to an integer representation of the value.
    #
    # @return [Integer]
    def to_i
      padded_hour_min.join.to_i
    end

    ##
    # Converts the time to an string representation of the value.
    #
    # @return [String]
    def to_s
      padded_hour_min.join(':')
    end

    private

    def padded_hour_min
      [hour, minute].map { |v| v.to_s.rjust(2, '0') }
    end
  end
end
