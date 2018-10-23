module GemFootprintAnalyzer
  module Formatters
    class TextBase
      def initialize(options={})
        @options = options
      end

      def info
        lines = []
        lines << "GemFootprintAnalyzer (#{GemFootprintAnalyzer::VERSION})\n"
        lines << "Analyze results (average measured from #{@options[:runs]} run(s))"
        lines << 'time is the amount of time given require has taken to complete'
        lines << 'RSS is total memory increase up to the point after the require'
        lines << "\n"
        lines.join("\n")
      end

      def dash(length)
        '-' * length
      end
    end
  end
end