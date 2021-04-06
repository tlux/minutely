# frozen_string_literal: true

RSpec.describe DayTime::TimeRange do
  describe '#initialize' do
    it 'sets #from from first arg' do
      from = DayTime::Time.new(12, 0)
      to = DayTime::Time.new(17, 45)

      subject = described_class.new(from, to)

      expect(subject.from).to be from
    end

    it 'sets #to from second arg' do
      from = DayTime::Time.new(12, 0)
      to = DayTime::Time.new(17, 45)

      subject = described_class.new(from, to)

      expect(subject.to).to be to
    end

    it 'allows setting to arg to 0 am' do
      from = DayTime::Time.new(12, 0)
      to = DayTime::Time.new(0, 0)

      subject = described_class.new(from, to)

      expect(subject.from).to be from
      expect(subject.to).to be to
    end
  end

  describe '.parse' do
    context 'nil' do
      it 'returns nil' do
        expect(described_class.parse(nil)).to be nil
      end
    end

    context 'DayTime::TimeRange' do
      it 'returns same instance' do
        time = described_class.new(14, 32)

        expect(described_class.parse(time)).to be time
      end
    end

    context 'Array' do
      it 'raises when array has less than 2 elements' do
        expect { described_class.parse([]) }
          .to raise_error ArgumentError, 'invalid time range'

        expect { described_class.parse([123]) }
          .to raise_error ArgumentError, 'invalid time range'
      end

      it 'raises when array has 3 elements' do
        expect { described_class.parse([123, 234, 345]) }
          .to raise_error ArgumentError, 'invalid time range'
      end

      it 'returns DayTime::TimeRange when start and end are integers' do
        expect(described_class.parse([123, 234]))
          .to eq DayTime::TimeRange.new('1:23', '2:34')
      end

      it 'returns DayTime::TimeRange when start and end are strings' do
        expect(described_class.parse(['1:23', '2:34']))
          .to eq DayTime::TimeRange.new('1:23', '2:34')
      end
    end

    context 'Hash' do
      it 'returns nil for empty hash' do
        expect(described_class.parse({})).to be nil
      end

      it 'returns DayTime::TimeRange for valid start and end' do
        expect(described_class.parse(from: '1:23', to: '2:34'))
          .to eq DayTime::TimeRange.new('1:23', '2:34')
      end

      it 'raises when Hash does not include both :from and :to keys' do
        expect { described_class.parse(foo: 'bar') }.to raise_error KeyError
      end

      it 'raises when Hash does not include :from key' do
        expect { described_class.parse(to: '2:34') }.to raise_error KeyError
      end

      it 'raises when Hash does not include :to key' do
        expect { described_class.parse(from: '1:23') }.to raise_error KeyError
      end

      it 'raises when :from invalid' do
        expect { described_class.parse(from: 'invalid', to: '2:34') }
          .to raise_error ArgumentError, 'invalid time string'
      end

      it 'raises when :to invalid' do
        expect { described_class.parse(from: '1:23', to: 'invalid') }
          .to raise_error ArgumentError, 'invalid time string'
      end
    end

    context 'String' do
      it 'returns nil on empty string' do
        expect(described_class.parse('')).to be nil
      end

      it 'returns DayTime::TimeRange for valid start and end' do
        subject = described_class.parse('14:00-17:45')

        expect(subject.from.hour).to eq 14
        expect(subject.from.minute).to eq 0
        expect(subject.to.hour).to eq 17
        expect(subject.to.minute).to eq 45
      end

      it 'returns DayTime::TimeRange for valid start and 0:00 end' do
        subject = described_class.parse('14:00-00:00')

        expect(subject.from.hour).to eq 14
        expect(subject.from.minute).to eq 0
        expect(subject.to.hour).to eq 0
        expect(subject.to.minute).to eq 0
      end

      it 'raises when string invalid' do
        expect { described_class.parse('invalid') }
          .to raise_error ArgumentError, 'invalid time range'

        expect { described_class.parse('14:00-') }
          .to raise_error ArgumentError, 'invalid time range'

        expect { described_class.parse('-14:00') }
          .to raise_error ArgumentError, 'invalid time range'

        expect { described_class.parse('14:00') }
          .to raise_error ArgumentError, 'invalid time range'

        expect { described_class.parse('14:00-15:00-16:00') }
          .to raise_error ArgumentError, 'invalid time range'
      end
    end

    context 'unknown' do
      it 'raises on parse error' do
        expect { described_class.parse(:unknown) }
          .to raise_error ArgumentError, 'invalid time range'
      end
    end
  end

  describe '#to_s' do
    it 'converts to string' do
      expect(described_class.new('9:00', '16:45').to_s).to eq '09:00-16:45'
    end
  end

  describe '#as_json' do
    it 'returns result of #to_s' do
      subject = described_class.new('9:00', '16:45')

      expect(subject.as_json).to eq subject.to_s
    end
  end
end
