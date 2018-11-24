require_relative 'require_spy'
require_relative 'transport'

module GemFootprintAnalyzer
  # A class that is loaded by the child process to faciliate require tracing.
  # When `start_child_context` env is passed, it is instantiated and start is called automatically
  # on require.
  class ChildContext
    PARENT_FIFO = '/tmp/parent'.freeze
    CHILD_FIFO = '/tmp/child'.freeze

    # Prints the process pid, so it can be grabbed by the supervisor process, inits tranport fifos
    # and requires requested libraries.
    def initialize
      output Process.pid
      init_transport
      require_rubygems_if_needed
      require_bundler_if_needed
    end

    # Installs the require-spying code and starts requiring
    def start
      RequireSpy.spy_require(transport)
      error = try_require(require_string)
      return transport.done_and_wait_for_ack unless error

      transport.exit_with_error(error)
      exit(1)
    end

    private

    attr_reader :transport

    def child_fifo
      ENV['child_fifo']
    end

    def parent_fifo
      ENV['parent_fifo']
    end

    def require_string
      ENV['require_string']
    end

    def analyze_gemfile
      ENV['analyze_gemfile']
    end

    def require_rubygems
      ENV['require_rubygems']
    end

    def try_require(require_string)
      error = nil
      begin
        analyze_gemfile ? Bundler.require : require(require_string)
      rescue LoadError => error
        warn_about_load_error(error)
      rescue Exception => error # rubocop:disable Lint/RescueException
        warn_about_error(error)
      end
      error
    end

    def init_transport
      write_stream = File.open(child_fifo, 'w')
      read_stream = File.open(parent_fifo, 'r')

      @transport = Transport.new(read_stream: read_stream, write_stream: write_stream)
    end

    def output(message)
      STDOUT.puts(message)
      STDOUT.flush
    end

    def require_rubygems_if_needed
      return unless require_rubygems

      require 'rubygems'
    end

    def require_bundler_if_needed
      return unless analyze_gemfile

      require 'bundler/setup'
    end

    def warn_about_load_error(error)
      possible_gem = error.message.split.last
      STDERR.puts "Cannot load '#{possible_gem}', this might be an issue with implicit require in" \
        " the '#{require_string}'"
      STDERR.puts "If '#{possible_gem}' is a gem, you can try adding it to the Gemfile explicitly" \
        ", running `bundle install` and trying again\n\n"
      warn_about_error(error)
    end

    def warn_about_error(error)
      STDERR.puts error.backtrace
      STDERR.flush
    end
  end
end

GemFootprintAnalyzer::ChildContext.new.start if ENV['start_child_context']
