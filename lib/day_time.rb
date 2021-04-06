# frozen_string_literal: true

require_relative 'day_time/version'

##
# A library that provides classes for representing the time of a day by using
# only hours and minutes.
module DayTime
  autoload :Time, 'day_time/time'
  autoload :TimeRange, 'day_time/time_range'
end
