require 'gem_footprint_analyzer/child_context'
require 'tempfile'

RSpec.describe GemFootprintAnalyzer::ChildContext do
  subject(:instance) { described_class.new }

  let(:transport) { instance_double(GemFootprintAnalyzer::Transport) }
  let(:require_string) { 'time' }

  around do |example|
    Tempfile.open('fifo') do |tf|
      ENV['parent_fifo'] = tf.path
      ENV['child_fifo'] = tf.path

      example.call
    end
  end

  context 'when file is required with start_child_context env var' do
    subject(:action) { load('gem_footprint_analyzer/child_context.rb') }

    let(:context_double) { instance_double(described_class) }

    before do
      ENV['start_child_context'] = 'true'
    end

    # rubocop:disable RSpec/ExpectOutput
    around do |example| # Silence constant overriding warnings from the load method
      previous_stderr = $stderr
      $stderr = StringIO.new
      example.call
      $stderr = previous_stderr
    end
    # rubocop:enable RSpec/ExpectOutput

    it 'calls instantiates the class and calls start' do
      expect(described_class).to receive(:new).and_return(context_double)
      expect(context_double).to receive(:start)

      action
    end
  end

  describe '#initialize' do
    it 'outputs pid and inits transport' do
      expect(STDOUT).to receive(:puts).with(Process.pid)
      instance
    end
  end

  describe '#start' do
    subject(:action) { instance.start }

    before do
      allow(STDOUT).to receive(:puts).with(Process.pid)
      allow(instance).to receive(:transport).and_return(transport)

      ENV['require_string'] = require_string
    end

    context 'when no errors' do
      it 'calls RequireSpy.spy_require and transport.done_and_wait_for_ack' do
        expect(GemFootprintAnalyzer::RequireSpy).to receive(:spy_require).with(transport)
        expect(transport).to receive(:done_and_wait_for_ack)

        action
      end
    end

    context 'when require ends with load error' do
      let(:require_string) { 'foobar' }

      it 'calls RequireSpy.spy_require and transport.exit_with_error' do
        expect(GemFootprintAnalyzer::RequireSpy).to receive(:spy_require).with(transport)
        expect(transport).to receive(:exit_with_error).with(an_instance_of(LoadError))
        expect(STDERR).to receive(:puts).exactly(3).times
        expect { action }.to raise_error(SystemExit)
      end
    end
  end
end
