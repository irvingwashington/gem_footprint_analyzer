module GemFootprintAnalyzer
  class Analyzer

    def test_library(library, require_string=nil)
      try_activate_gem(library)

      child_transport, parent_transport = init_transports

      process_id = fork_and_require(require_string || library, child_transport)
      requires = collect_requires(parent_transport, process_id)

      parent_transport.ack
      requires
    end

    private

    def fork_and_require(require_string, child_transport)
      GC.start
      process_id = fork do
        RequireSpy.spy_require(child_transport)
        begin
          require(require_string)
        rescue LoadError => e
          child_transport.exit_with_error(e)
          exit
        end
        child_transport.done
        child_transport.wait_for_ack
      end
      Process.detach(process_id)
      process_id
    end

    def collect_requires(parent_transport, process_id)
      base_rss = nil
      requires = []
      while (msg, payload = parent_transport.read_one_command)
        if msg == :require
          curr_rss = rss(process_id)
          name, time = payload
          requires << {name: name, time: Float(time) * 1000, rss: curr_rss - base_rss}
        elsif msg == :already_required
        elsif msg == :ready
          unless base_rss
            base_rss = rss(process_id)
            requires << {base: true, rss: base_rss}
          end
          parent_transport.start
        elsif msg == :exit
          puts "Exiting because of exception: #{payload}"
          exit 1
        elsif msg == :done
          break
        end
      end
      requires
    end

    def try_activate_gem(library)
      gem(library)
    rescue Gem::LoadError
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

      child_transport = GemFootprintAnalyzer::PipeTransport.new(child_reader, child_writer)
      parent_transport = GemFootprintAnalyzer::PipeTransport.new(parent_reader, parent_writer)

      [child_transport, parent_transport]
    end
  end
end