RSpec.describe GemFootprintAnalyzer::CoreExt::Hash do
  subject(:klass) { Class.new(Hash).tap { |h| h.prepend(described_class) } }

  describe '#dig' do
    subject { klass[[[:a, 1], [:b, {c: 2}]]].dig(*args) }

    context 'when existing key passed' do
      let(:args) { :a }

      it { is_expected.to eq(1) }
    end

    context 'when not existing key passed' do
      let(:args) { :c }

      it { is_expected.to be nil }
    end

    context 'when existing keys passed' do
      let(:args) { %i[b c] }

      it { is_expected.to be 2 }
    end

    context 'when non existing keys passed' do
      let(:args) { %i[b d] }

      it { is_expected.to be nil }
    end

    context 'when other non existing keys passed' do
      let(:args) { %i[z d] }

      it { is_expected.to be nil }
    end
  end
end
