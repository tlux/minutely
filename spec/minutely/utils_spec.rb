# frozen_string_literal: true

RSpec.describe Minutely::Utils do
  describe '.blank?' do
    it 'is true when arg is nil' do
      expect(described_class.blank?(nil)).to be true
    end

    it 'is true when arg is empty string' do
      expect(described_class.blank?('')).to be true
    end

    it 'is true when arg is empty Array' do
      expect(described_class.blank?([])).to be true
    end

    it 'is false when arg is non-empty string' do
      expect(described_class.blank?('foo')).to be false
    end

    it 'is true when arg is non-empty Array' do
      expect(described_class.blank?([:foo])).to be false
    end
  end
end
