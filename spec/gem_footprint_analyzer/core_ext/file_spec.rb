RSpec.describe GemFootprintAnalyzer::CoreExt::File do
  subject(:klass) { Class.new(File).tap { |f| f.extend(described_class) } }

  describe '.mkfifo' do
    context 'when file is writeable' do
      let(:filename) { File.join('/tmp', "test_#{Process.pid}.fifo") }

      it 'creates the FIFO file' do
        klass.mkfifo(filename)
        expect(File.exist?(filename)).to be true
        File.unlink(filename)
      end
    end

    context 'when file is not writeable' do
      let(:filename) { File.join('/tmp') }

      it 'fails with an exception' do
        expect { klass.mkfifo(filename) }.to raise_exception('Failed to make FIFO special file')
      end
    end
  end
end
