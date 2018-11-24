module GemFootprintAnalyzer
  module CoreExt
    # Provides Array#sum, missing in Ruby 2.2.0
    module Array
      # Sums over the array
      def sum(init = 0, &block)
        if block
          reduce(init) { |acc, el| acc + yield(el) }
        else
          reduce(init) { |acc, el| acc + el }
        end
      end
    end
  end
end

Array.include(GemFootprintAnalyzer::CoreExt::Array) unless [].respond_to?(:sum)
