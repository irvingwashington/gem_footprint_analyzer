module GemFootprintAnalyzer
  module Formatters
    # A formatter class outputting bare JSON.
    # Useful for integrating with other tools.
    class Json
      # Initializer conforms to formatters interface
      def initialize(*); end

      # @return [String] A JSON form of the requires_list array, last entry is the cumulated result.
      def format_list(requires_list)
        require 'json'

        JSON.dump(requires_list)
      end
    end
  end
end
