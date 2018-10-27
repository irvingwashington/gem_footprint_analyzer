module GemFootprintAnalyzer
  # A class that faciliates sampling of the original require and subsequent require calls from
  # within the library.
  # It forks the original process and runs the first require in that fork explicitly.
  # Require calls are interwoven with RSS checks done from the parent process, require timing
  # is gathered in the fork and passed along to the parent.
  class Analyzer
    # @param library [String] name of the library or parameter for the gem method
    #   (ex. 'activerecord', 'activesupport')
    # @param require_string [String|nil] optional require string, if it differs from the gem name
    #   (ex. 'active_record', 'active_support/time')
    # @return [Array<Hash>] list of require-data-hashes, first element contains base level RSS,
    #   last element can be treated as a summary as effectively it consists of all the previous.
    def test_library(library, require_string = nil)
      try_activate_gem(library)

      child_transport, parent_transport = init_transports

      process_id = fork_and_require(require_string || library, child_transport)
      detach_process(process_id)
      requires = collect_requires(parent_transport, process_id)

      parent_transport.ack
      requires
    end

    private

    def fork_and_require(require_string, child_transport)
      fork do
        RequireSpy.spy_require(child_transport)
        begin
          require(require_string)
        rescue LoadError => e
          child_transport.exit_with_error(e)
          exit
        end
        child_transport.done_and_wait_for_ack
      end
    end

    def detach_process(pid)
      Process.detach(pid)
      at_exit { Process.kill('TERM', pid) }
      pid
    end

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

    def try_activate_gem(library)
      gem(library)
    rescue Gem::LoadError
      nil
    end

    def pkill(process_id)
      Process.kill('TERM', process_id)
    end

    def rss(process_id)
      `ps -o rss -p #{process_id}`.split.last.strip.to_i
    end

    def init_transports
      child_reader, parent_writer = IO.pipe
      parent_reader, child_writer = IO.pipe

      child_transport = GemFootprintAnalyzer::Transport.new(child_reader, child_writer)
      parent_transport = GemFootprintAnalyzer::Transport.new(parent_reader, parent_writer)

      [child_transport, parent_transport]
    end
  end
end
