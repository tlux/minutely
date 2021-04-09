# frozen_string_literal: true

RSpec.describe Minutely::TimeRange do
  it 'includes Comparable' do
    expect(described_class).to include Comparable
  end

  it 'includes Enumerable' do
    expect(described_class).to include Enumerable
  end

  describe '#initialize' do
    it 'sets #from from first arg' do
      from = Minutely::Time.new(12, 0)
      to = Minutely::Time.new(17, 45)

      subject = described_class.new(from, to)

      expect(subject.from).to be from
    end

    it 'sets #to from second arg' do
      from = Minutely::Time.new(12, 0)
      to = Minutely::Time.new(17, 45)

      subject = described_class.new(from, to)

      expect(subject.to).to be to
    end

    it 'sets #exclude_end? to false by default' do
      subject = described_class.new(0, 0)

      expect(subject.exclude_end?).to be false
    end

    it 'sets #exclude_end? from option' do
      subject = described_class.new(0, 0, exclude_end: true)

      expect(subject.exclude_end?).to be true
    end

    it 'allows setting to arg to 0 am' do
      from = Minutely::Time.new(12, 0)
      to = Minutely::Time.new(0, 0)

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

    context 'Minutely::TimeRange' do
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

      it 'returns Minutely::TimeRange when start and end are integers' do
        expect(described_class.parse([123, 234]))
          .to eq Minutely::TimeRange.new('1:23', '2:34')
      end

      it 'returns Minutely::TimeRange when start and end are strings' do
        expect(described_class.parse(['1:23', '2:34']))
          .to eq Minutely::TimeRange.new('1:23', '2:34')
      end
    end

    context 'Hash' do
      it 'returns nil for empty hash' do
        expect(described_class.parse({})).to be nil
      end

      it 'returns Minutely::TimeRange for valid start and end' do
        expect(described_class.parse(from: '1:23', to: '2:34'))
          .to eq Minutely::TimeRange.new('1:23', '2:34')
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

      it 'returns Minutely::TimeRange for valid start and end' do
        subject = described_class.parse('14:00-17:45')

        expect(subject.from.hour).to eq 14
        expect(subject.from.minute).to eq 0
        expect(subject.to.hour).to eq 17
        expect(subject.to.minute).to eq 45
      end

      it 'returns Minutely::TimeRange for valid start and 0:00 end' do
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

  describe '#to_a' do
    it 'converts to array' do
      subject = described_class.new('9:57', '10:03')

      expect(subject.to_a.map(&:to_s)).to eq %w[
        09:57
        09:58
        09:59
        10:00
        10:01
        10:02
        10:03
      ]
    end

    it 'converts to array, excluding end' do
      subject = described_class.new('9:57', '10:03', exclude_end: true)

      expect(subject.to_a.map(&:to_s)).to eq %w[
        09:57
        09:58
        09:59
        10:00
        10:01
        10:02
      ]
    end

    it 'converts single element range to array' do
      subject = described_class.new('9:57', '9:57')

      expect(subject.to_a.map(&:to_s)).to eq ['09:57']
    end

    it 'converts single element range with excluded end to empty array' do
      subject = described_class.new('9:57', '9:57', exclude_end: true)

      expect(subject.to_a).to eq []
    end

    it 'converts to array, spanning 12 am' do
      subject = described_class.new('23:57', '0:03')

      expect(subject.to_a.map(&:to_s)).to eq %w[
        23:57
        23:58
        23:59
        00:00
        00:01
        00:02
        00:03
      ]
    end

    it 'converts to array, spanning 12 am, excluding end' do
      subject = described_class.new('23:57', '0:03', exclude_end: true)

      expect(subject.to_a.map(&:to_s)).to eq %w[
        23:57
        23:58
        23:59
        00:00
        00:01
        00:02
      ]
    end
  end

  describe '#spanning_midnight?' do
    it 'is true when range is spanning midnight' do
      [%w[23:57 0:03], %w[23:57 0:00]].each do |(from, to)|
        subject = described_class.new(from, to)

        expect(subject.spanning_midnight?).to be true
      end
    end

    it 'is false when range is not spanning midnight' do
      [%w[9:57 10:03], %w[0:00 0:03], %w[23:57 23:59]].each do |(from, to)|
        subject = described_class.new(from, to)

        expect(subject.spanning_midnight?).to be false
      end
    end
  end

  describe '#to_r' do
    it 'converts to range' do
      subject = described_class.new('9:57', '10:03')

      expect(subject.to_r).to eq(subject.from..subject.to)
    end

    it 'converts to range, excluding end' do
      subject = described_class.new('9:57', '10:03', exclude_end: true)

      expect(subject.to_r).to eq(subject.from...subject.to)
    end

    it 'raises when range is #spanning_midnight?' do
      subject = described_class.new('23:57', '0:03')

      expect { subject.to_r }.to raise_error(
        RuntimeError,
        'Unable to convert ranges spanning midnight'
      )
    end

    it 'raises when range is excluding end and #spanning_midnight?' do
      subject = described_class.new('23:57', '0:03', exclude_end: true)

      expect { subject.to_r }.to raise_error(
        RuntimeError,
        'Unable to convert ranges spanning midnight'
      )
    end
  end

  describe '#to_s' do
    it 'converts to string' do
      expect(described_class.new('9:00', '16:45').to_s).to eq '09:00-16:45'
    end
  end

  describe '#as_json' do
    subject { described_class.new('9:00', '16:45') }

    it 'returns result of #to_s with no arguments' do
      expect(subject.as_json).to eq subject.to_s
    end

    it 'returns result of #to_s with 1 argument' do
      expect(subject.as_json({})).to eq subject.to_s
    end
  end

  describe '#<=>' do
    subject { described_class.new('9:00', '10:00') }

    it 'is nil when other object is no time range' do
      expect(subject <=> :other).to be nil
    end

    it 'is nil when other time range does #exclude_end?' do
      other = described_class.new('9:00', '10:00', exclude_end: true)

      expect(subject <=> other).to be nil
    end

    it 'is 0 when equal' do
      other = described_class.new('9:00', '10:00')

      expect(subject <=> other).to eq 0
    end

    it 'is 1 when time range is less than other' do
      other = described_class.new('8:30', '9:30')

      expect(subject <=> other).to eq 1
    end

    it 'is -1 when time range is less than other' do
      other = described_class.new('10:30', '11:30')

      expect(subject <=> other).to eq(-1)
    end
  end

  describe '#include?' do
    subject { described_class.new('9:00', '16:45') }

    it 'is true when time range includes time' do
      expect(subject.include?('9:00')).to be true
      expect(subject.include?('12:30')).to be true
      expect(subject.include?('16:45')).to be true
    end

    it 'is false when time range not includes time' do
      expect(subject.include?('0:00')).to be false
      expect(subject.include?('8:59')).to be false
      expect(subject.include?('16:46')).to be false
    end

    it 'is false when time range expected to include #to when #exclude_end?' do
      subject = described_class.new('9:00', '16:45', exclude_end: true)

      expect(subject.include?('16:45')).to be false
    end

    it 'raises when argument invalid' do
      expect { subject.include?('14:000') }
        .to raise_error ArgumentError, 'invalid time string'

      expect { subject.include?(14_000) }
        .to raise_error ArgumentError, 'invalid hour'
    end
  end
end
