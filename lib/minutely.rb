# frozen_string_literal: true

require_relative 'minutely/version'

##
# A library that provides classes for representing the time of a day by using
# only hours and minutes.
module Minutely
  autoload :Parser, 'minutely/parser'
  autoload :StringAsJson, 'minutely/string_as_json'
  autoload :Time, 'minutely/time'
  autoload :TimeRange, 'minutely/time_range'
  autoload :Utils, 'minutely/utils'

  module_function

  ##
  # Parses the given input and returns a `Minutely::Time` or `nil`,
  # respectively.
  #
  # @param obj [Minutely::Time, #hour, #min, Integer, String, nil]
  #
  # @return [Minutely::Time, nil]
  #
  # @raise [ArgumentError] when the object does not represent a valid time
  def parse(*args)
    Minutely::Time.parse(*args)
  end

  ##
  # Parses the given input and returns a `Minutely::TimeRange` or `nil`,
  # respectively.
  #
  # @param obj [Minutely::TimeRange, Array, Hash, String, nil]
  #
  # @return [Minutely::TimeRange, nil]
  #
  # @raise [ArgumentError] when the object does not represent a valid time range
  #
  # @raise [KeyError] when the given Hash does not contain the required keys
  #   (`:from` and `:to`)
  def parse_range(*args)
    Minutely::TimeRange.parse(*args)
  end
end
