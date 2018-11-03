module GemFootprintAnalyzer
  module CoreExt
    # Provides File#mkfifo, missing in Ruby 2.2.0
    module File
      def mkfifo(name)
        system("mkfifo #{name}")
      end
    end
  end
end
File.extend(GemFootprintAnalyzer::CoreExt::File) unless File.respond_to?(:mkfifo)
