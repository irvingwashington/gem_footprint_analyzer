require 'gem_footprint_analyzer/require_spy'

RSpec.describe GemFootprintAnalyzer::RequireSpy do
  describe '.relative_path' do
    subject { described_class.relative_path(caller_entry, require_name) }

    let(:caller_entry) { "ruby-2.5.3/lib/ruby/2.5.0/uri.rb:112:in '<top (required)>'" }

    around do |example|
      $LOAD_PATH.unshift('ruby-2.5.3/lib/ruby/2.5.0')
      example.call
      $LOAD_PATH.delete('ruby-2.5.3/lib/ruby/2.5.0')
    end

    context 'when require_name is set' do
      let(:require_name) { 'uri' }

      it { is_expected.to eq 'uri' }
    end

    context 'when require_name is not set' do
      let(:require_name) { nil }

      it { is_expected.to eq 'uri.rb' }
    end
  end

  describe '.first_foreign_caller' do
    subject { described_class.first_foreign_caller(caller_list) }

    context 'when list contains foreign caller' do
      let(:caller_list) do
        [
          "gem_footprint_analyzer/lib/gem_footprint_analyzer/require_spy.rb:54:in 'require'",
          "gem_footprint_analyzer/lib/gem_footprint_analyzer/require_spy.rb:54:in 'block (2 levels) in define_require'",
          "gem_footprint_analyzer/lib/gem_footprint_analyzer/require_spy.rb:42:in 'block in define_timed_exec'",
          "gem_footprint_analyzer/lib/gem_footprint_analyzer/require_spy.rb:54:in 'block in define_require'",
          "ruby-2.5.3/lib/ruby/2.5.0/uri.rb:112:in '<top (required)>'",
          "gem_footprint_analyzer/lib/gem_footprint_analyzer/require_spy.rb:54:in 'require'"
        ]
      end

      it { is_expected.to eq('ruby-2.5.3/lib/ruby/2.5.0/uri') }
    end

    context 'when list contains no foreign caller' do
      let(:caller_list) do
        [
          "gem_footprint_analyzer/lib/gem_footprint_analyzer/require_spy.rb:54:in 'require'",
          "gem_footprint_analyzer/lib/gem_footprint_analyzer/require_spy.rb:54:in 'block in define_require'",
          "gem_footprint_analyzer/lib/gem_footprint_analyzer/require_spy.rb:54:in 'require'"
        ]
      end

      it { is_expected.to be nil }
    end
  end

  describe '.spy_require' do
    subject(:action) { described_class.spy_require(transport) }

    let(:transport) { instance_double(GemFootprintAnalyzer::Transport) }

    it 'calls all helper functions' do
      expect(described_class).to receive(:alias_require_methods)
      expect(described_class).to receive(:define_timed_exec)
      expect(described_class).to receive(:define_require_relative)
      expect(described_class).to receive(:define_require).with(transport)

      action
    end
  end

  describe '.alias_require_methods' do
    subject(:action) { described_class.alias_require_methods }

    it 'aliases require and require_relative' do
      expect(Kernel).to receive(:alias_method).with(:regular_require, :require)
      expect(Kernel).to receive(:alias_method).with(:regular_require_relative, :require_relative)

      action
    end
  end

  shared_examples 'defines the method' do |method_name|
    it 'defines the method' do
      expect(Kernel).to receive(:define_method).with(method_name)

      action
    end
  end

  describe '.define_timed_exec' do
    subject(:action) { described_class.define_timed_exec }

    include_examples 'defines the method', :timed_exec
  end

  describe '.define_require' do
    subject(:action) { described_class.define_require(transport) }

    let(:transport) { instance_double(GemFootprintAnalyzer::Transport) }

    include_examples 'defines the method', :require
  end

  describe '.define_require_relative' do
    subject(:action) { described_class.define_require_relative }

    include_examples 'defines the method', :require_relative
  end
end
