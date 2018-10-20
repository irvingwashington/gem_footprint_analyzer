module GemFootprintAnalyzer
  class JsonFormatter
    require 'json'
    def format(requires_list)
      JSON.dump(requires_list)
    end
  end
end
