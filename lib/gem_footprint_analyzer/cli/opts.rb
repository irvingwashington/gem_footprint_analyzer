require 'optparse'

module GemFootprintAnalyzer
  class CLI
    # A class dealing with command line options parsing, validation and displaying banner and
    # help messages.
    class Opts
      # @param options [Hash<Symbol>]
      def initialize(options)
        @options = options
      end

      # @param args [Array<String>]
      def parse!(args)
        parser.parse!(args)
      end

      # @return [OptionParser]
      def parser # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        @parser ||= OptionParser.new do |opts|
          opts.banner = banner
          opts.on('-f', '--formatter FORMATTER', %w[json tree],
                  'Format output using selected formatter (json tree)') do |formatter|

            options[:formatter] = formatter
          end

          opts.on('-n', '--runs-num NUMBER', OptParse::DecimalInteger, 'Number of runs') do |runs|
            fail OptionParser::InvalidArgument, 'must be a number greater than 0' if runs < 1

            options[:runs] = runs
          end

          opts.on('-r', '--rubygems', 'Require rubygems before the actual analyze') do |rubygems|
            options[:rubygems] = rubygems
          end

          opts.on('-g', '--gemfile', 'Analyze current Gemfile') do
            validate_bundler_presence

            options[:rubygems] = true
            options[:analyze_gemfile] = true
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

      attr_reader :options

      private

      def banner
        script_name = "bundle exec #{File.basename($PROGRAM_NAME)}"

        "GemFootprintAnalyzer (#{GemFootprintAnalyzer::VERSION})\n" \
          "Usage: #{script_name} library_to_analyze [require]"
      end

      def debug_banner
        "\n(#{File.expand_path(File.join(File.dirname(__FILE__), '..'))})"
      end

      def validate_bundler_presence
        require 'rubygems'
        require 'bundler/setup'

        Bundler.root
      rescue LoadError => e
        puts "Bundler gem is not available, please install it first (#{e})"

        exit 1
      rescue GemfileNotFound => e
        puts "No Gemfile found (#{e})"

        exit 1
      end
    end
  end
end
