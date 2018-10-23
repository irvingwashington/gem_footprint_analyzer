module GemFootprintAnalyzer
  module Formatters
    class Tree < TextBase
      INDENT = '  '.freeze

      class Entry
        def initialize(entry_hash, options={})
          @entry_hash = entry_hash
          @options = {}
        end

        def name
          @entry_hash[:name]
        end

        def parent
          @entry_hash[:parent_name]
        end

        def time
          time = @entry_hash.dig(:time, :mean)&.round
        end

        def rss
          @entry_hash.dig(:rss, :mean)&.round
        end

        def formatted_name
          "#{name}#{debug_parent}"
        end

        private

        def debug_parent
          return unless @options[:debug]

          "(#{parent})"
        end
      end

      def format(requires_list)
        return if requires_list.size == 1

        entries = requires_list.last(requires_list.size - 1).map { |entry_hash| Entry.new(entry_hash, @options) }

        root = entries.last
        indent_levels = {root.name => 0}


        (entries - [root]).reverse.each do |entry|
          indent_levels[entry.name] ||= indent_levels.fetch(entry.parent, 0) + 1
        end

        max_name_length = entries.map { |e| e.formatted_name.length }.max
        max_indent = indent_levels.values.max

        ljust_value = max_name_length + (max_indent *  INDENT.size) + 1


        lines = entries.reverse.map do |entry|
          indent = INDENT * indent_levels[entry.name]
          time = "%5dms" % entry.time
          rss = "%7dKB"  % entry.rss

          "#{indent}#{entry.formatted_name}".ljust(ljust_value) + time + rss
        end
        lines.unshift(dash(ljust_value + 16))
        lines.unshift('name'.ljust(ljust_value + 2) + 'time' + '   RSS after')
        info + lines.join("\n")
      end
    end
  end
end
