RSpec.describe GemFootprintAnalyzer::CLI do
  subject(:cli) { described_class.new }

  let(:requires) do
    [
      {base: true, rss: {mean: 7894.8, stddev: 15.4}},
      {name: 'date_core', parent_name: 'date', rss: {mean: 504, stddev: 30}, time: {mean: 0.75, stddev: 0.05}},
      {name: 'date', parent_name: 'time', rss: {mean: 504, stddev: 30}, time: {mean: 1.5, stddev: 0.04}},
      {name: 'time', parent_name: '', rss: {mean: 504, stddev: 30}, time: {mean: 4, stddev: 0.1}}
    ]
  end

  describe '#run' do
    subject(:action) { cli.run(args) }

    context 'when args provided' do
      context 'when provided with no flags' do
        let(:args) { ['time'] }
        let(:result) do
          <<-RESULT
GemFootprintAnalyzer (#{GemFootprintAnalyzer::VERSION})

Analyze results (average measured from 10 run(s))
time is the amount of time given require has taken to complete
RSS is total memory increase up to the point after the require

name            time   RSS after
------------------------------
time              4ms    504KB
  date            2ms    504KB
    date_core     1ms    504KB
          RESULT
        end

        it 'outputs tree' do
          expect(cli).to receive(:capture_requires).and_return(requires)

          expect { action }.to output(result).to_stdout
        end
      end

      context 'when provided with json formatter' do
        let(:args) { ['-f', 'json', 'time'] }
        let(:result) do
          <<-RESULT
[{"base":true,"rss":{"mean":7894.8,"stddev":15.4}},{"name":"date_core","parent_name":"date","rss":{"mean":504,"stddev":30},"time":{"mean":0.75,"stddev":0.05}},{"name":"date","parent_name":"time","rss":{"mean":504,"stddev":30},"time":{"mean":1.5,"stddev":0.04}},{"name":"time","parent_name":"","rss":{"mean":504,"stddev":30},"time":{"mean":4,"stddev":0.1}}]
          RESULT
        end

        it 'outputs json' do
          expect(cli).to receive(:capture_requires).and_return(requires)
          expect { action }.to output(result).to_stdout
        end
      end

      context 'when provided with nums to run' do
        let(:args) { ['-n', '100', 'time'] }
        let(:runner_double) { instance_double(GemFootprintAnalyzer::AverageRunner, run: [base: 1]) }

        it 'inits AverageRunner with 100' do
          expect(GemFootprintAnalyzer::AverageRunner).to receive(:new).with(100)
                                                                      .and_return(runner_double)
          action
        end
      end

      context 'when provided with help flag' do
        let(:args) { ['-h'] }

        it 'prints banner and exits' do
          expect { action }.to output(/Usage:/).to_stdout.and raise_error(SystemExit)
        end
      end

      context 'when provided with unknown option' do
        let(:args) { ['-z'] }

        it 'fails' do
          expect { action }.to raise_error(OptionParser::InvalidOption, /-z/)
        end
      end
    end

    context 'when args empty' do
      let(:args) { [] }

      it 'prints banner and exits' do
        expect { action }.to output(/Usage:/).to_stdout.and raise_error(SystemExit)
      end
    end
  end
end
