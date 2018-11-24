module GemFootprintAnalyzer
  module CoreExt
    # Provides Hash#dig, missing in Ruby 2.2.0
    module Hash
      # @param keys [Array<Symbol|String>] list of keys to dig from the hash
      def dig(*keys)
        value = self
        keys.each do |key|
          return nil if !value.respond_to?(:key) || !value.key?(key)

          value = value[key]
        end
        value
      end
    end
  end
end

Hash.include(GemFootprintAnalyzer::CoreExt::Hash) unless {}.respond_to?(:dig)
