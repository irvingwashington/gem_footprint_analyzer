require 'tmpdir'

module GemFootprintAnalyzer
  # A command line interface class for the gem.
  # Provides options parsing and help messages for the user.
  class CLI
    def initialize
      @options = {}
      @options[:runs] = 10
      @options[:debug] = false
      @options[:formatter] = 'tree'

      @opts = Opts.new(@options)
    end

    # @param args [Array<String>] runs the analyzer with parsed args taken as options
    # @return [void]
    def run(args = ARGV)
      opts.parse!(args)

      if !analyze_gemfile? && args.empty?
        puts opts.parser
        exit 1
      end

      print_requires(options, args)
    end

    private

    def print_requires(options, args)
      requires_list_average = capture_requires(options, args)
      formatter = formatter_instance(options)
      output = formatter.new(options).format_list(requires_list_average)

      Utils.safe_puts(output)
    end

    attr_reader :options, :opts

    def capture_requires(options, args)
      GemFootprintAnalyzer::AverageRunner.new(options[:runs]) do
        fifos = init_fifos

        GemFootprintAnalyzer::Analyzer.new(fifos, options).test_library(*args).tap do
          clean_up_fifos(fifos)
        end
      end.run
    end

    def init_fifos
      dir = Dir.mktmpdir
      parent_name = File.join(dir, 'parent.fifo')
      child_name = File.join(dir, 'child.fifo')

      File.mkfifo(parent_name)
      File.mkfifo(child_name)

      {parent: parent_name, child: child_name}
    end

    def clean_up_fifos(fifos)
      fifos.each { |_, name| File.unlink(name) if File.exist?(name) }
      Dir.unlink(File.dirname(fifos[:parent]))
    end

    def formatter_instance(options)
      GemFootprintAnalyzer::Formatters.const_get(options[:formatter].capitalize)
    end

    def analyze_gemfile?
      options[:analyze_gemfile]
    end
  end
end
