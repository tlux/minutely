# frozen_string_literal: true

module DayTime
  ##
  # A mixin to use #to_s as JSON representation of the including object.
  module StringAsJson
    ##
    # The JSON representation of the object as Hash. Conventionally used by
    # common serializers.
    #
    # @return [Hash]
    def as_json(_options = nil)
      to_s
    end
  end
end
