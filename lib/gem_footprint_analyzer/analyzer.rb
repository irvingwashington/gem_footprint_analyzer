module GemFootprintAnalyzer
  # A class that faciliates sampling of the original require and subsequent require calls from
  # within the library.
  # It initializes ChildProcess and uses it to start the require cycle in a controlled environment.
  # Require calls are interwoven with RSS checks done from the parent process, require timing
  # is gathered in the child process and passed along to the parent.
  class Analyzer
    # @param fifos [Hash<Symbol>] Hash containing filenames of :child and :parent FIFO files
    def initialize(fifos, options = {})
      @options = options
      @fifos = fifos
    end

    # @param library [String|nil] name of the library or parameter for the gem method
    #   (ex. 'activerecord', 'activesupport').
    #   Nil if user wants to analyze the whole Gemfile
    # @param require_string [String|nil] optional require string, if it differs from the gem name
    #   (ex. 'active_record', 'active_support/time')
    # @return [Array<Hash>] list of require-data-hashes, first element contains base level RSS,
    #   last element can be treated as a summary as effectively it consists of all the previous.
    def test_library(library = nil, require_string = nil)
      child = ChildProcess.new(library, require_string, fifos, options)
      child.start_child
      parent_transport = init_transport
      requires = collect_requires(parent_transport, child.pid)

      parent_transport.ack
      requires
    end

    private

    attr_reader :fifos, :options

    def collect_requires(transport, process_id)
      requires_context = {base_rss: nil, requires: [], process_id: process_id, transport: transport}

      while (cmd = transport.read_one_command)
        msg, payload = cmd

        break unless handle_command(msg, payload, requires_context)
      end

      requires_context[:requires]
    end

    def handle_command(msg, payload, context)
      case msg
      when :require
        context[:requires] << handle_require(context[:process_id], context[:base_rss], payload)
      when :ready
        handle_ready(context)
        context[:transport].start
      when :done then return false
      when :exit then handle_exit(payload)
      end
      true
    end

    def handle_require(process_id, base_rss, payload)
      cur_rss = rss(process_id) -  base_rss
      name, parent_name, time = payload

      {name: name, parent_name: parent_name, time: Float(time) * 1000, rss: cur_rss}
    end

    def handle_exit(payload)
      puts "Exiting because of exception: #{payload}"
      exit 1
    end

    def handle_ready(context)
      return if context[:base_rss]

      context[:base_rss] = rss(context[:process_id])
      context[:requires] << {base: true, rss: context[:base_rss]}
    end

    def rss(process_id)
      `ps -o rss -p #{process_id}`.split.last.strip.to_i
    end

    def init_transport
      reader = File.open(fifos[:child], 'r')
      writer = File.open(fifos[:parent], 'w')

      Transport.new(read_stream: reader, write_stream: writer)
    end
  end
end
