module GemFootprintAnalyzer
  class CLI
    # A module containing helper methods for CLI
    module Utils
      # Outputs strings to STDOUT, in case it's no longer possible (ex. when piped to head),
      # it exits the process.
      # @param output [String] message to be outputted to STDOUT
      def self.safe_puts(output)
        output ||= "\n"

        string_output = output.is_a?(String) ? output : output.join("\n")

        puts string_output
      rescue Errno::EPIPE
        exit
      end
    end
  end
end
