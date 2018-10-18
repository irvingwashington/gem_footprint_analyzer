module RequireFootprintAnalyzer
  class PipeTransport
    def initialize(read_stream, write_stream)
      @read_stream = read_stream
      @write_stream = write_stream
    end

    def read_one_command
      str = @read_stream.gets.strip

      case str
      when /\Adone\z/
        [:done, nil]
      when /\Aack\z/
        [:ack, nil]
      when /\Arq: "([^"]+)",(.+)\z/
        [:require, [$1, $2]]
      when /\Aarq: "([^"]+)"\z/
        [:already_required, $1]
      when /\Astart\z/
        [:start, nil]
      when /\Aready\z/
        [:ready, nil]
      when /\Aexit: "([^"]+)"\z/
        [:exit, $1]
      end
    end

    def wait_for_start
      while (msg, payload = read_one_command)
        break if msg == :start
      end
    end

    def wait_for_ack
      while (msg, data = read_one_command)
        break if msg == :ack
      end
    end

    def ready
      @write_stream.puts 'ready'
    end

    def start
      @write_stream.puts 'start'
    end

    def ack
      @write_stream.puts 'ack'
    end

    # Signalize finalization
    def done
      @write_stream.puts 'done'
    end

    def report_require(library, duration)
      @write_stream.puts "rq: #{library.inspect},#{duration.inspect}"
    end

    def report_already_required(library)
      @write_stream.puts "arq: #{library.inspect}"
    end

    def exit_with_error(e)
      @write_stream.puts "exit: #{e.to_s.inspect}"
    end
  end
end
