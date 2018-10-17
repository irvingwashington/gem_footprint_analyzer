module RequireFootprintAnalyzer
  class Analyzer
    def test_library(library, require_string=nil)
      require_string ||= library
      begin
        gem(library)
      rescue Gem::LoadError
      end
      child_transport, parent_transport = init_transports
      result_hash = {}
      GC.start

      process_id = fork do
        RequireSpy.spy_require(child_transport)
        begin
          require(require_string)
        rescue LoadError => e
          child_transport.exit_with_error(e)
          exit
        end
        sleep 1
        child_transport.done

        while (msg, data = child_transport.read_one_command)
          break if msg == :ack
        end
      end

      Process.detach(process_id)

      base_rss = nil
      requires = []

      while (msg, payload = parent_transport.read_one_command)
        if msg == :require
          curr_rss = rss(process_id)
          name, time = payload
          requires << {name: name, time: Float(time), rss: curr_rss - base_rss}
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
      parent_transport.ack
      requires
    end

    private

    def pkill(process_id)
      Process.kill('TERM', process_id)
    end

    def rss(process_id)
      `ps -o rss -p #{process_id}`.split.last.strip.to_i
    end

    def init_transports
      child_reader, parent_writer = IO.pipe
      parent_reader, child_writer = IO.pipe

      child_transport = RequireFootprintAnalyzer::PipeTransport.new(child_reader, child_writer)
      parent_transport = RequireFootprintAnalyzer::PipeTransport.new(parent_reader, parent_writer)

      [child_transport, parent_transport]
    end
  end
end