module GemFootprintAnalyzer
  module Formatters
    # A formatter class outputting bare JSON.
    # Useful for integrating with other tools.
    class Json
      require 'json'

      def initialize(*); end

      # @return [String] A JSON form of the requires_list array, last entry is the cumulated result.
      def format_list(requires_list)
        JSON.dump(requires_list)
      end
    end
  end
end
