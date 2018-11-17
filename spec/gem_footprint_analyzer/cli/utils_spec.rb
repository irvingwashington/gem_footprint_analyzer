RSpec.describe GemFootprintAnalyzer::CLI::Utils do
  describe '.safe_puts' do
    subject(:action) { described_class.safe_puts(message) }

    let(:message) { 'Hello World' }

    context 'when message is nil' do
      let(:message) { nil }

      it 'outputs new line' do
        expect { action }.to output("\n").to_stdout
      end
    end

    context 'when message is not nil' do
      it 'outputs it with new line' do
        expect { action }.to output("#{message}\n").to_stdout
      end
    end

    context 'when puts raises Errno::EPIPE' do
      before do
        allow(STDOUT).to receive(:puts) { fail(Errno::EPIPE) }
      end

      it 'exits' do
        expect { action }.to raise_exception(SystemExit)
      end
    end
  end
end
