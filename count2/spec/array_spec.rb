require 'rspec'
require_relative '../lib/array'

RSpec.describe Array do
  let(:ary) { [1, 2, 4, 2] }

  subject { ary.count2 }

  describe '#count2' do
    it 'return number of elements in array' do
      is_expected.to eq(4)
    end

    it 'returns integer' do
      is_expected.to be_kind_of(Integer)
    end

    context 'when specific element given' do
      it 'counts specific elements of array' do
        expect(ary.count2(2)).to eq(2)
      end
    end

    context 'when block given' do
      it 'counts elements selected in the block' do
        expect(ary.count2 { |x| x%2 == 0 }).to eq(3)
      end
    end
  end
end

