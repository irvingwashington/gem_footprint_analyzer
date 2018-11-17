RSpec.describe GemFootprintAnalyzer::CLI::Opts do
  subject(:instance) { described_class.new(options) }

  let(:options) { {} }

  shared_examples 'fails with a message' do |msg, ex = OptionParser::InvalidArgument|
    specify do
      expect { action }.to raise_exception(ex, msg)
    end
  end

  describe '#parse!' do
    subject(:action) { instance.parse!(args) }

    let(:args) { [] }

    context 'with -f option' do
      context 'when correct formatter passed' do
        let(:args) { %w[-f json] }

        it 'sets the formatter' do
          expect { action }.to change { instance.options[:formatter] }.to('json')
        end
      end

      context 'when incorrect formatter passed' do
        let(:args) { %w[-f yaml] }

        include_examples 'fails with a message', /-f/
      end

      context 'when no formatter passed' do
        let(:args) { %w[-f] }

        include_examples 'fails with a message', /-f/, OptionParser::MissingArgument
      end
    end

    context 'with -n option' do
      context 'when positive integer num value' do
        let(:args) { %w[-n 1984] }

        it 'sets number of runs param' do
          expect { action }.to change { instance.options[:runs] }.to(1984)
        end
      end

      context 'when num is zero' do
        let(:args) { ['-n', '0'] }

        include_examples 'fails with a message', /greater than 0/
      end

      context 'when num below zero' do
        let(:args) { ['-n', '-10'] }

        include_examples 'fails with a message', /greater than 0/
      end

      context 'when num empty' do
        let(:args) { ['-n'] }

        include_examples 'fails with a message', /-n/, OptionParser::MissingArgument
      end
    end

    context 'with -r option' do
      let(:args) { %w[-r] }

      it 'sets rubygems flag' do
        expect { action }.to change { instance.options[:rubygems] }.to(true)
      end
    end

    context 'with -g option' do
      let(:args) { %w[-g] }

      it 'sets analyze_gemfile flag' do
        expect { action }.to change { instance.options[:analyze_gemfile] }.to(true)
      end
    end

    context 'with -d option' do
      let(:args) { %w[-d] }

      it 'sets debug flag' do
        expect { action }.to change { instance.options[:debug] }.to(true)
      end
    end

    context 'with -h option' do
      let(:args) { %w[-h] }

      it 'exits with help message' do
        expect { action }.to output(/Usage:/).to_stdout.and raise_exception(SystemExit)
      end
    end
  end

  describe '#parser' do
    subject { instance.parser }

    it { is_expected.to be_a(OptionParser) }
  end
end
