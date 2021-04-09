# frozen_string_literal: true

require 'date'
require 'ostruct'

RSpec.describe Minutely::Time do
  it 'includes Comparable' do
    expect(described_class).to include Comparable
  end

  describe '#initialize' do
    subject { described_class.new(14, 32) }

    it 'sets #hour from first arg' do
      expect(subject.hour).to eq 14
    end

    it 'sets #minute from second arg' do
      expect(subject.minute).to eq 32
    end

    it 'sets #hour to 0 when first arg is 24' do
      subject = described_class.new(24, 12)

      expect(subject.hour).to eq 0
      expect(subject.minute).to eq 12
    end

    it 'raises ArgumentError when hour negative' do
      expect { described_class.new(-1, 32) }
        .to raise_error ArgumentError, 'invalid hour'
    end

    it 'raises ArgumentError when hour greater than 24' do
      expect { described_class.new(25, 32) }
        .to raise_error ArgumentError, 'invalid hour'
    end

    it 'raises ArgumentError when minute negative' do
      expect { described_class.new(14, -1) }
        .to raise_error ArgumentError, 'invalid minute'
    end

    it 'raises ArgumentError when minute greater than 59' do
      expect { described_class.new(14, 60) }
        .to raise_error ArgumentError, 'invalid minute'
    end
  end

  describe '.beginning_of_day' do
    it 'is 0:00' do
      expect(described_class.beginning_of_day).to eq described_class.new(0, 0)
    end
  end

  describe '.end_of_day' do
    it 'is 0:00' do
      expect(described_class.end_of_day).to eq described_class.new(23, 59)
    end
  end

  describe '.parse' do
    context 'nil' do
      it 'returns nil' do
        expect(described_class.parse(nil)).to be nil
      end
    end

    context 'Minutely::Time' do
      it 'returns same instance' do
        time = described_class.new(14, 32)

        expect(described_class.parse(time)).to be time
      end
    end

    context 'DateTime' do
      it 'returns Minutely::Time' do
        datetime = DateTime.now

        expect(described_class.parse(datetime))
          .to eq described_class.new(datetime.hour, datetime.minute)
      end
    end

    context 'Time' do
      it 'returns Minutely::Time' do
        time = Time.now

        expect(described_class.parse(time))
          .to eq described_class.new(time.hour, time.min)
      end
    end

    context 'String' do
      it 'returns nil on empty string' do
        expect(described_class.parse('')).to be nil
      end

      it 'returns Minutely::Time on success' do
        expect(described_class.parse('14:32')).to eq described_class.new(14, 32)
        expect(described_class.parse('03:04')).to eq described_class.new(3, 4)
        expect(described_class.parse('3:04')).to eq described_class.new(3, 4)
      end

      it 'raises on parse error' do
        expect { described_class.parse('14:') }
          .to raise_error ArgumentError, 'invalid time string'

        expect { described_class.parse(':2') }
          .to raise_error ArgumentError, 'invalid time string'

        expect { described_class.parse('14:2') }
          .to raise_error ArgumentError, 'invalid time string'

        expect { described_class.parse('invalid!') }
          .to raise_error ArgumentError, 'invalid time string'
      end

      it 'raises on init error' do
        expect { described_class.parse('25:02') }
          .to raise_error ArgumentError, 'invalid hour'

        expect { described_class.parse('00:61') }
          .to raise_error ArgumentError, 'invalid minute'
      end
    end

    context 'Integer' do
      it 'returns Minutely::Time on success' do
        expect(described_class.parse(1432)).to eq described_class.new(14, 32)
        expect(described_class.parse(304)).to eq described_class.new(3, 4)
        expect(described_class.parse(0)).to eq described_class.new(0, 0)
      end

      it 'raises on init error' do
        expect { described_class.parse(2502) }
          .to raise_error ArgumentError, 'invalid hour'

        expect { described_class.parse(61) }
          .to raise_error ArgumentError, 'invalid minute'
      end
    end

    context 'unknown' do
      it 'raises on parse error' do
        expect { described_class.parse(:unknown) }
          .to raise_error ArgumentError, 'invalid time'
      end
    end
  end

  describe '#<=>' do
    it 'is nil when other object does not respond to #hour' do
      time = described_class.new(14, 32)
      no_time = OpenStruct.new(minute: 32)

      expect(time <=> no_time).to be nil
    end

    it 'is nil when other object does not respond to #minute' do
      time = described_class.new(14, 32)
      no_time = OpenStruct.new(hour: 14)

      expect(time <=> no_time).to be nil
    end

    it 'is 0 when Minutely::Times are equal' do
      time1 = described_class.new(14, 32)
      time2 = described_class.new(14, 32)

      expect(time1 <=> time2).to eq 0
    end

    it 'is -1 when first Minutely::Time is less' do
      time1 = described_class.new(14, 31)
      time2 = described_class.new(14, 32)
      time3 = described_class.new(15, 32)

      expect(time1 <=> time2).to eq(-1)
      expect(time1 <=> time3).to eq(-1)
      expect(time2 <=> time3).to eq(-1)
    end

    it 'is 1 when second Minutely::Time is greater' do
      time1 = described_class.new(15, 32)
      time2 = described_class.new(14, 32)
      time3 = described_class.new(14, 31)

      expect(time1 <=> time2).to eq 1
      expect(time1 <=> time3).to eq 1
      expect(time2 <=> time3).to eq 1
    end
  end

  describe '#succ' do
    it 'returns next minute' do
      expect(described_class.new(12, 31).succ).to eq described_class.new(12, 32)
    end

    it 'returns next minute at 23:59' do
      expect(described_class.new(23, 59).succ).to eq described_class.new(0, 0)
    end

    it 'returns next minute at 12:59' do
      expect(described_class.new(12, 59).succ).to eq described_class.new(13, 0)
    end
  end

  describe '#to_i' do
    it 'converts time to integer' do
      expect(described_class.new(14, 32).to_i).to eq 1432
    end

    it 'pads minute' do
      expect(described_class.new(3, 9).to_i).to eq 309
    end
  end

  describe '#to_s' do
    it 'converts time to string' do
      expect(described_class.new(14, 32).to_s).to eq '14:32'
    end

    it 'pads hour and minute' do
      expect(described_class.new(3, 9).to_s).to eq '03:09'
    end
  end

  describe '#as_json' do
    subject { described_class.new(14, 32) }

    it 'returns result of #to_s with no argument' do
      expect(subject.as_json).to eq subject.to_s
    end

    it 'returns result of #to_s with 1 argument' do
      expect(subject.as_json({})).to eq subject.to_s
    end
  end
end
