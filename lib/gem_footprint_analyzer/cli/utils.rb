module GemFootprintAnalyzer
  class CLI
    # A module containing helper methods for CLI
    module Utils
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
