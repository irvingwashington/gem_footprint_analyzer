module GemFootprintAnalyzer
  module Formatters
    class Json
      require 'json'

      def initialize(*)
      end

      def format(requires_list)
        JSON.dump(requires_list)
      end
    end
  end
end
