# frozen_string_literal: true

module DayTime
  ##
  # A class that represents a day time by using only hours and minutes.
  #
  # @!attribute [r] hour
  #   @return [Fixnum]
  #
  # @!attribute [r] minute
  #   @return [Fixnum]
  class Time
    include Comparable

    attr_reader :hour, :minute
    alias min minute

    ##
    # Builds a new `MinuteTime`.
    #
    # @param hour [Fixnum] a number between 0 and 23
    #
    # @param minute [Fixnum] a number between 0 and 59
    #
    # @raise [ArgumentError] when arguments are not within the specified ranges
    def initialize(hour, minute)
      raise ArgumentError, 'invalid hour' unless (0..23).include?(hour)
      raise ArgumentError, 'invalid minute' unless (0..59).include?(minute)

      @hour = hour
      @minute = minute
    end

    ##
    # Parses the given input and returns a `MinuteTime` or `nil`, respectively.
    #
    # @param obj [MinuteTime, #hour, #min, Fixnum, String, nil]
    #
    # @return [MinuteTime, nil]
    #
    # @raise [ArgumentError] when the object does not represent a valid time
    def self.parse(obj)
      return nil if obj.blank?
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

    def <=>(other)
      return nil unless other.is_a?(self.class)

      [hour, minute] <=> [other.hour, other.minute]
    end

    ##
    # Gets the next minute as new `MinuteTime`.
    #
    # @return [MinuteTime]
    def succ
      return self.class.new((hour + 1) % 24, 0) if minute == 59

      self.class.new(hour, minute + 1)
    end

    def to_i
      padded_hour_min.join.to_i
    end

    def to_s
      padded_hour_min.join(':')
    end

    alias as_json to_s

    private

    def padded_hour_min
      [hour, minute].map { |v| v.to_s.rjust(2, '0') }
    end
  end
end
