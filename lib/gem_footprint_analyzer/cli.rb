require 'optparse'

module GemFootprintAnalyzer
  # A command line interface class for the gem.
  # Provides options parsing and help messages for the user.
  class CLI
    def initialize
      @options = {}
      @options[:runs] = 10
      @options[:debug] = false
      @options[:formatter] = 'tree'
      @options[:skip_rubygems] = false
    end

    # @param args [Array<String>] runs the analyzer with parsed args taken as options
    # @return [void]
    def run(args = ARGV)
      opts_parser.parse!(args)

      if args.empty?
        puts opts_parser
        exit 1
      end
      require 'rubygems' unless options[:skip_rubygems]

      print_requires(options, args)
    end

    private

    def print_requires(options, args)
      requires_list_average = capture_requires(options, args)
      at_exit { clean_up }
      formatter = formatter_instance(options)
      puts formatter.new(options).format_list(requires_list_average)
    end

    attr_reader :options

    def capture_requires(options, args)
      GemFootprintAnalyzer::AverageRunner.new(options[:runs]) do
        GemFootprintAnalyzer::Analyzer.new.test_library(*args)
      end.run
    end

    def formatter_instance(options)
      require 'gem_footprint_analyzer/formatters/text_base'
      require 'gem_footprint_analyzer/formatters/tree'
      require 'gem_footprint_analyzer/formatters/json'

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
          raise OptionParser::InvalidArgument, 'must be a number greater than 0' if runs < 1

          options[:runs] = runs
        end

        opts.on('-d', '--debug', 'Show debug information') do |debug|
          opts.banner += debug_banner if debug

          options[:debug] = debug
        end

        opts.on(
          '-g', '--disable-gems',
          'Don\'t require rubygems (recommended for standard library analyses)'
        ) do |skip_rubygems|

          options[:skip_rubygems] = skip_rubygems
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

    def clean_up
      fork_waiters = Thread.list.select { |th| th.is_a?(Process::Waiter) }
      fork_waiters.each { |waiter| Process.kill('TERM', waiter.pid) }
    end
  end
end
