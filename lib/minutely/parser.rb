module Minutely
  class Parser
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def self.parse(value)
      new(value).parse
    end

    def parse
      raise NotImplementedError
    end
  end
end
