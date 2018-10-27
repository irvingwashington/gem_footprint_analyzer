module GemFootprintAnalyzer
  module Formatters
    # Base class for all text formatters.
    # Houses boilerplate and disclaimer text methods.
    class TextBase
      # @param options [Hash<Symbol>] A hash of CLI options, to be used in disclaimer text
      def initialize(options = {})
        @options = options
      end

      # Displays explanatory words for text formatter results
      def info
        lines = []
        lines << "GemFootprintAnalyzer (#{GemFootprintAnalyzer::VERSION})\n"
        lines << "Analyze results (average measured from #{@options[:runs]} run(s))"
        lines << 'time is the amount of time given require has taken to complete'
        lines << 'RSS is total memory increase up to the point after the require'
        lines << "\n"
        lines.join("\n")
      end

      # @return [String] Awesome text separator
      def dash(length)
        '-' * length
      end
    end
  end
end
