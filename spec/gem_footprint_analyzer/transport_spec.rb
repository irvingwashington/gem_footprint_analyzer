RSpec.describe GemFootprintAnalyzer::Transport do
  subject(:transport) { described_class.new(**streams) }

  let(:streams) { {read_stream: read_stream, write_stream: write_stream} }

  let(:write_stream) { StringIO.new }
  let(:read_stream) { StringIO.new(read_buffer) }

  let(:write_buffer) { write_stream.string }
  let(:read_buffer) { '' }

  describe '#read_one_command' do
    subject { transport.read_one_command }

    %w[done ack start ready].each do |cmd|
      context "when #{cmd}" do
        let(:read_buffer) { "#{cmd}\n" }

        it { is_expected.to eq([cmd.to_sym, nil]) }
      end
    end

    context 'when rq' do
      let(:read_buffer) { 'rq: "date","time",0.002' }

      it { is_expected.to eq([:require, ['date', 'time', '0.002']]) }
    end

    context 'when arq' do
      let(:read_buffer) { 'arq: "date"' }

      it { is_expected.to eq([:already_required, 'date']) }
    end

    context 'when exit' do
      let(:read_buffer) { 'exit: "StandardError"' }

      it { is_expected.to eq([:exit, 'StandardError']) }
    end

    context 'when unknown command' do
      let(:read_buffer) { 'unknown' }

      it { is_expected.to be nil }
    end
  end

  describe '#wait_for_start' do
    subject(:action) { transport.wait_for_start }

    let(:read_buffer) { "foo\nbar\nstart" }

    # Doesn't really test that, since StringIO is non-blocking
    it 'reads until gets start' do
      action
    end
  end

  describe '#done_and_wait_for_ack' do
    subject(:action) { transport.done_and_wait_for_ack }

    let(:read_buffer) { "ack\n" }

    it 'writes done and waits for ack' do
      action
      expect(write_buffer).to eq("done\n")
    end
  end

  shared_examples 'writes command' do |command|
    specify do
      action
      expect(write_buffer).to eq("#{command}\n")
    end
  end

  describe '#ready' do
    subject(:action) { transport.ready }

    include_examples 'writes command', 'ready'
  end

  describe '#start' do
    subject(:action) { transport.start }

    include_examples 'writes command', 'start'
  end

  describe '#ack' do
    subject(:action) { transport.ack }

    include_examples 'writes command', 'ack'
  end

  describe '#report_require' do
    subject(:action) { transport.report_require(library, source, duration) }

    let(:library) { 'date' }
    let(:source) { 'time' }
    let(:duration) { 0.02 }

    specify do
      action
      expect(write_buffer).to eq(%(rq: "date","time",0.02\n))
    end
  end

  describe '#report_already_required' do
    subject(:action) { transport.report_already_required(library) }

    let(:library) { 'date' }

    specify do
      action
      expect(write_buffer).to eq(%(arq: "date"\n))
    end
  end

  describe '#exit_with_error' do
    subject(:action) { transport.exit_with_error(error) }

    let(:error) { 'StandardError' }

    specify do
      action
      expect(write_buffer).to eq(%(exit: "StandardError"\n))
    end
  end
end
