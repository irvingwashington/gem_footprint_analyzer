require 'tempfile'

RSpec.describe GemFootprintAnalyzer::Analyzer do
  subject(:instance) { described_class.new(fifos) }

  let(:fifos) { {child: child_fifo, parent: parent_fifo} }

  let(:child_fifo) { Tempfile.open('child') }
  let(:parent_fifo) { Tempfile.open('parent') }

  after do
    child_fifo.unlink
    parent_fifo.unlink
  end

  describe '#test_library' do
    subject(:action) { instance.test_library(library, require_string) }

    let(:library) { 'time' }
    let(:require_string) { nil }
    let(:child_process_double) { instance_double(GemFootprintAnalyzer::ChildProcess) }
    let(:transport_double) { instance_double(GemFootprintAnalyzer::Transport) }

    it 'calls all helper methods' do # rubocop:disable RSpec/ExampleLength:
      expect(child_process_double).to receive(:start_child)
      expect(child_process_double).to receive(:pid).and_return(666)
      expect(transport_double).to receive(:ack)

      expect(GemFootprintAnalyzer::ChildProcess).to receive(:new)
        .with(library, require_string, fifos)
        .and_return(child_process_double)

      expect(instance).to receive(:init_transport).and_return(transport_double)
      expect(instance).to receive(:collect_requires)
        .with(transport_double, 666)
        .and_return('foobar')

      expect(action).to match('foobar')
    end
  end

  # TODO: test private methods
end
