RSpec.describe GemFootprintAnalyzer::CoreExt::Array do
  subject(:klass) { Class.new(Array).tap { |h| h.prepend(described_class) } }

  describe '#sum' do
    context 'when no block given' do
      subject { klass[*values].sum(init_value) }

      let(:init_value) { 0 }

      context 'when there are values' do
        let(:values) { [1, 2, 3] }

        it { is_expected.to eq(6) }

        context 'when init value is non zero' do
          let(:init_value) { 10 }

          it { is_expected.to eq(16) }
        end
      end

      context 'when there is value' do
        let(:values) { [1] }

        it { is_expected.to eq(1) }
      end

      context 'when no values' do
        let(:values) { [] }

        it { is_expected.to eq(0) }
      end
    end
  end
end
