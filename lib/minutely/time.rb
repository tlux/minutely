# frozen_string_literal: true

module Minutely
  ##
  # A class that represents a day time by using only hours and minutes.
  #
  # @!attribute [r] hour
  #   @return [Integer]
  #
  # @!attribute [r] minute
  #   @return [Integer]
  class Time
    autoload :Parser, 'minutely/time/parser'

    include Comparable
    include StringAsJson

    attr_reader :hour, :minute
    alias min minute

    ##
    # Builds a new `Minutely::Time`.
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
    # @return [Minutely::Time]
    def self.beginning_of_day
      new(0, 0)
    end

    ##
    # Returns the end of day.
    #
    # @return [Minutely::Time]
    def self.end_of_day
      new(23, 59)
    end

    ##
    # Parses the given input and returns a `Minutely::Time` or `nil`,
    # respectively.
    #
    # @param value [Minutely::Time, #hour, #min, Integer, String, nil]
    #
    # @return [Minutely::Time, nil]
    #
    # @raise [ArgumentError] when the object does not represent a valid time
    def self.parse(value)
      Time::Parser.parse(value)
    end

    ##
    # Compares the time to another one.
    #
    # @return [Integer]
    def <=>(other)
      return nil unless other.is_a?(self.class)

      [hour, minute] <=> [other.hour, other.minute]
    end

    ##
    # Gets the next minute as new `Minutely::Time`.
    #
    # @return [Minutely::Time]
    def succ
      return self.class.new((hour + 1) % 24, 0) if minute == 59

      self.class.new(hour, minute + 1)
    end

    ##
    # Converts the time to an integer representation of the value.
    #
    # @return [Integer]
    def to_i
      100 * hour + minute
    end

    ##
    # Converts the time to an string representation of the value.
    #
    # @return [String]
    def to_s
      [hour, minute].map { |v| v.to_s.rjust(2, '0') }.join(':')
    end
  end
end
