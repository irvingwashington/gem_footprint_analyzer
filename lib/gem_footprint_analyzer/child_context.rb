require_relative 'require_spy'
require_relative 'transport'

module GemFootprintAnalyzer
  # A class that is loaded by the child process to faciliate require tracing.
  # When `start_child_context` env is passed, it is instantiated and start is called automatically
  # on require.
  class ChildContext
    PARENT_FIFO = '/tmp/parent'.freeze
    CHILD_FIFO = '/tmp/child'.freeze

    def initialize
      output Process.pid
      init_transport
    end

    # Installs the require-spying code and starts requiring
    def start
      RequireSpy.spy_require(transport)
      begin
        require(require_string)
      rescue LoadError => e
        warn_about_load_error(e)
        transport.exit_with_error(e)
        exit 1
      end
      transport.done_and_wait_for_ack
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

    def init_transport
      write_stream = File.open(child_fifo, 'w')
      read_stream = File.open(parent_fifo, 'r')

      @transport = Transport.new(read_stream: read_stream, write_stream: write_stream)
    end

    def output(message)
      STDOUT.puts(message)
      STDOUT.flush
    end

    def warn_about_load_error(error)
      possible_gem = error.message.split.last
      STDERR.puts "Cannot load '#{possible_gem}', this might be an issue with implicit require in" \
        " the '#{require_string}'"
      STDERR.puts "If '#{possible_gem}' is a gem, you can try adding it to the Gemfile explicitly" \
        ", running `bundle install` and trying again\n\n"
      STDERR.puts error.backtrace
      STDERR.flush
    end
  end
end

GemFootprintAnalyzer::ChildContext.new.start if ENV['start_child_context']
