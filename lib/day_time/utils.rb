# frozen_string_literal: true

module DayTime
  ##
  # Provides utility functions to be internally used by the DayTime library.
  module Utils
    module_function

    ##
    # Determines whether the given value is nil or empty.
    #
    # @return [Boolean]
    def blank?(value)
      value.nil? || (value.respond_to?(:empty?) && value.empty?)
    end
  end
end
