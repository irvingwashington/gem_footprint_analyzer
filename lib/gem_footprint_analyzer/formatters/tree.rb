module GemFootprintAnalyzer
  # Tree type formatter for results.
  module Formatters
    # Prints results with the cumulated entry first and details below, indented to give
    # information about the calling order of subsequent requires.
    class Tree < TextBase
      INDENT = '  '.freeze
      # Formatter helper class representing a single results require entry.
      class Entry
        def initialize(entry_hash, _options = {})
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
          time = @entry_hash.dig(:time, :mean)
          time && time.round
        end

        def rss
          rss = @entry_hash.dig(:rss, :mean)
          rss && rss.round
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

      def format_list(requires_list)
        return if requires_list.size == 1

        entries = init_entries(requires_list)
        info + formatted_entries(entries)
      end

      private

      def formatted_entries(entries)
        indent_levels, max_indent = count_indent_levels(entries)
        max_name_length = entries.map { |e| e.name.length }.max
        ljust_value = max_name_length + max_indent + 1

        lines = entries.reverse.map do |entry|
          format_entry(entry, indent_levels, ljust_value)
        end

        (legend(ljust_value) + lines).join("\n")
      end

      def legend(ljust_value)
        [
          'name'.ljust(ljust_value + 2) + 'time' + '   RSS after',
          dash(ljust_value + 16)
        ]
      end

      def format_entry(entry, indent_levels, ljust_value)
        indent = INDENT * indent_levels[entry.name]
        time = format('%5dms', entry.time)
        rss = format('%7dKB', entry.rss)

        "#{indent}#{entry.formatted_name}".ljust(ljust_value) + time + rss
      end

      def init_entries(requires_list)
        requires_list.last(requires_list.size - 1).map do |entry_hash|
          Entry.new(entry_hash, @options)
        end
      end

      def count_indent_levels(entries)
        root = entries.last
        indent_levels = {root.name => 0}

        (entries - [root]).reverse_each do |entry|
          indent_levels[entry.name] ||= indent_levels.fetch(entry.parent, 0) + 1
        end
        max_indent = indent_levels.values.max

        [indent_levels, max_indent * INDENT.size]
      end
    end
  end
end
