require 'optparse'
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

      try_require_bundler
    end

    # @param args [Array<String>] runs the analyzer with parsed args taken as options
    # @return [void]
    def run(args = ARGV)
      opts_parser.parse!(args)

      if args.empty?
        puts opts_parser
        exit 1
      end

      print_requires(options, args)
    end

    private

    def print_requires(options, args)
      requires_list_average = capture_requires(options, args)
      formatter = formatter_instance(options)
      puts formatter.new(options).format_list(requires_list_average)
    end

    attr_reader :options

    def capture_requires(options, args)
      GemFootprintAnalyzer::AverageRunner.new(options[:runs]) do
        fifos = init_fifos

        GemFootprintAnalyzer::Analyzer.new(fifos).test_library(*args).tap do
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

    def opts_parser # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      @opts_parser ||= OptionParser.new do |opts|
        opts.banner = banner
        opts.on('-f', '--formatter FORMATTER', %w[json tree],
                'Format output using selected formatter (json tree)') do |formatter|

          options[:formatter] = formatter
        end

        opts.on('-n', '--runs-num NUMBER', OptParse::DecimalInteger, 'Number of runs') do |runs|
          fail OptionParser::InvalidArgument, 'must be a number greater than 0' if runs < 1

          options[:runs] = runs
        end

        opts.on('-d', '--debug', 'Show debug information') do |debug|
          opts.banner += debug_banner if debug

          options[:debug] = debug
        end

        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end
      end
    end

    def banner
      script_name = "bundle exec #{File.basename($PROGRAM_NAME)}"

      "GemFootprintAnalyzer (#{GemFootprintAnalyzer::VERSION})\n" \
        "Usage: #{script_name} library_to_analyze [require]"
    end

    def debug_banner
      "\n(#{File.expand_path(File.join(File.dirname(__FILE__), '..'))})"
    end

    def try_require_bundler
      require 'bundler/setup'
    rescue LoadError
      nil
    end
  end
end
