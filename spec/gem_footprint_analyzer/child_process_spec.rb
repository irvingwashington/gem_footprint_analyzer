RSpec.describe GemFootprintAnalyzer::ChildProcess do
  subject(:instance) { described_class.new(library, require_string, fifos) }

  let(:library) { 'time' }
  let(:require_string) { nil }
  let(:fifos) { {parent: 'parent.fifo', child: 'child.fifo'} }

  describe '#start_child' do
    subject(:action) { instance.start_child }

    before do
      allow(instance).to receive(:context_file).and_return('child_context.rb')
      stub_const('GemFootprintAnalyzer::ChildProcess::RUBY_CMD', ['ruby', '--param'])
    end

    it 'runs new Ruby process in another thread' do # rubocop:disable RSpec/ExampleLength
      expect(Open3).to receive(:popen3).with(
        hash_including(
          'require_string' => 'time',
          'start_child_context' => 'true',
          'child_fifo' => 'child.fifo',
          'parent_fifo' => 'parent.fifo',
          'RUBYOPT' => '',
          'RUBYLIB' => $LOAD_PATH.join(':')
        ), 'ruby', '--param', 'child_context.rb'
      )

      action.join
    end
  end

  describe '#pid' do
    subject(:action) { instance.pid }

    context 'when child_thread exists' do
      before { instance.instance_variable_set('@child_thread', true) }

      context 'when pid is already set' do
        before { instance.instance_variable_set('@pid', 66_666) }

        it { is_expected.to eq(66_666) }
      end

      context 'when pid is nil' do
        it 'waits until @pid is set' do
          expect(instance).to receive(:sleep).with(0.01) do
            instance.instance_variable_set('@pid', 66_666)
          end
          expect(action).to eq(66_666)
        end
      end
    end

    context 'when child_thread does not exist' do
      it { is_expected.to be nil }
    end
  end
end
