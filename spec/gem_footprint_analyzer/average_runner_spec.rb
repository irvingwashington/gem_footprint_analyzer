RSpec.describe GemFootprintAnalyzer::AverageRunner do
  subject(:instance) { described_class.new(runs, &run_block) }

  let(:run_block) { -> {} }
  let(:runs) { 1 }

  describe '#initialize' do
    context 'when runs is less than 1' do
      let(:runs) { 0 }

      it 'fails' do
        expect { instance }.to raise_error(ArgumentError, 'runs must be > 0')
      end
    end
  end

  describe '#run' do
    subject(:action) { instance.run }

    let(:run_block) { -> { [{}] } }
    let(:runs) { 5 }

    it 'runs run_once 5 times and calls calculate_averages with the result' do
      expect(instance).to receive(:run_once).exactly(5).times.and_return(1)
      expect(instance).to receive(:calculate_averages).with([1, 1, 1, 1, 1])

      action
    end
  end

  describe '#calculate_averages' do
    subject(:action) { instance.__send__(:calculate_averages, values) }

    let(:values) do
      [
        [
          {base: true, rss: 7904},
          {name: 'date_core', parent_name: 'date', time: 0.8, rss: 504},
          {name: 'date', parent_name: 'time', time: 1.6, rss: 504},
          {name: 'time', parent_name: '', time: 4.5, rss: 504}
        ],
        [
          {base: true, rss: 7852},
          {name: 'date_core', parent_name: 'date', time: 0.7, rss: 528},
          {name: 'date', parent_name: 'time', time: 1.5, rss: 528},
          {name: 'time', parent_name: '', time: 4.2, rss: 528}
        ]
      ]
    end

    it 'returns averaged results' do # rubocop:disable RSpec/ExampleLength
      expect(action).to eq([
                             {base: true, rss: {mean: 7878, stddev: 26.0}},
                             {name: 'date_core',
                              parent_name: 'date',
                              rss: {mean: 516, stddev: 12.0},
                              time: {mean: 0.75, stddev: 0.05}},
                             {name: 'date',
                              parent_name: 'time',
                              rss: {mean: 516.0, stddev: 12.0},
                              time: {mean: 1.55, stddev: 0.05}},
                             {name: 'time',
                              parent_name: '',
                              rss: {mean: 516.0, stddev: 12.0},
                              time: {mean: 4.35, stddev: 0.15}}
                           ])
    end
  end
end
