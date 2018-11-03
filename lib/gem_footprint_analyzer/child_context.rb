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
        transport.exit_with_error(e)
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
  end
end

GemFootprintAnalyzer::ChildContext.new.start if ENV['start_child_context']
