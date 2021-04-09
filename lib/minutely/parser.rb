# frozen_string_literal: true

module Minutely
  ##
  # An abstract class for defining custom parsers.
  #
  # @!attribute [r] value
  #   @return [Object]
  class Parser
    attr_reader :value

    ##
    # Initialize the parser.
    #
    # @param value [Object]
    def initialize(value)
      @value = value
    end

    ##
    # Parse the specified value.
    #
    # @param value [Object]
    # @return [Object]
    # @raise [ArgumentError]
    def self.parse(value)
      new(value).parse
    end
  end
end
