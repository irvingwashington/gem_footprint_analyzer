module GemFootprintAnalyzer
  # A basic transport class that provides a simple text interface and faciliates the
  # transmission via 2 streams.
  class Transport
    # @param read_stream [IO] stream that will be used to read from by this {Transport} instance
    # @param write_stream [IO] stream that will be used to write to by this {Transport} instance
    def initialize(read_stream:, write_stream:)
      @read_stream = read_stream
      @write_stream = write_stream
    end

    # @return [Array] A tuple with command and *payload
    def read_one_command
      case read_raw_command
      when /\A(done|ack|start|ready)\z/
        [Regexp.last_match(1).to_sym, nil]
      when /\Arq: "([^"]+)","([^"]*)",([^,]+)\z/
        [:require, [Regexp.last_match(1), Regexp.last_match(2), Regexp.last_match(3)]]
      when /\Aarq: "([^"]+)"\z/
        [:already_required, Regexp.last_match(1)]
      when /\Aexit: "([^"]+)"\z/
        [:exit, Regexp.last_match(1)]
      end
    end

    # Blocks until a :start command is received from the read stream
    def wait_for_start
      while (cmd = read_one_command)
        msg, = cmd
        break if msg == :start
      end
    end

    # Sends a done command and blocks until ack command is received
    def done_and_wait_for_ack
      write_raw_command 'done'
      while (cmd = read_one_command)
        msg, = cmd
        break if msg == :ack
      end
    end

    # Sends a ready command
    def ready
      write_raw_command 'ready'
    end

    # Sends a start command
    def start
      write_raw_command 'start'
    end

    # Sends an ack command
    def ack
      write_raw_command 'ack'
    end

    # @param library [String] Name of the library that was required
    # @param source [String] Name of the source file that required the library
    # @param duration [Float] Time which it took to complete the require
    def report_require(library, source, duration)
      write_raw_command "rq: #{library.inspect},#{source.inspect},#{duration.inspect}"
    end

    # @param library [String] Name of the library that was required, but was already required before
    def report_already_required(library)
      write_raw_command "arq: #{library.inspect}"
    end

    # @param error [Exception] Exception object that should halt the program
    def exit_with_error(error)
      write_raw_command "exit: #{error.to_s.inspect}"
    end

    private

    def write_raw_command(command)
      @write_stream.puts(command)
      @write_stream.flush
    end

    def read_raw_command
      @read_stream.gets.strip
    end
  end
end
