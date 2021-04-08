# frozen_string_literal: true

RSpec.describe DayTime do
  describe '.parse' do
    it 'is delegated to DayTime::Time.parse' do
      arg = double('arg')
      result = double('day time')

      expect(described_class::Time)
        .to receive(:parse).with(arg).and_return(result)

      expect(described_class.parse(arg)).to be result
    end
  end

  describe '.parse_range' do
    it 'is delegated to DayTime::TimeRange.parse' do
      arg = double('arg')
      result = double('day time range')

      expect(described_class::TimeRange)
        .to receive(:parse).with(arg).and_return(result)

      expect(described_class.parse_range(arg)).to be result
    end
  end
end
