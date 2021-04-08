# frozen_string_literal: true

require_relative 'day_time/version'

##
# A library that provides classes for representing the time of a day by using
# only hours and minutes.
module DayTime
  autoload :StringAsJson, 'day_time/string_as_json'
  autoload :Time, 'day_time/time'
  autoload :TimeRange, 'day_time/time_range'
  autoload :Utils, 'day_time/utils'

  module_function

  ##
  # Parses the given input and returns a `DayTime::Time` or `nil`, respectively.
  #
  # @param obj [DayTime::Time, #hour, #min, Fixnum, String, nil]
  #
  # @return [DayTime::Time, nil]
  #
  # @raise [ArgumentError] when the object does not represent a valid time
  def parse(*args)
    DayTime::Time.parse(*args)
  end

  ##
  # Parses the given input and returns a `DayTime::TimeRange` or `nil`,
  # respectively.
  #
  # @param obj [DayTime::TimeRange, Array, Hash, String, nil]
  #
  # @return [DayTime::TimeRange, nil]
  #
  # @raise [ArgumentError] when the object does not represent a valid time range
  #
  # @raise [KeyError] when the given Hash does not contain the required keys
  #   (`:from` and `:to`)
  def parse_range(*args)
    DayTime::TimeRange.parse(*args)
  end
end
