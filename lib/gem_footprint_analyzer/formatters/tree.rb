module GemFootprintAnalyzer
  # Tree type formatter for results.
  module Formatters
    # Prints results with the cumulated entry first and details below, indented to give
    # information about the calling order of subsequent requires.
    class Tree < TextBase
      INDENT = '  '.freeze
      # Formatter helper class representing a single results require entry.
      class Entry
        BUNDLER_RUNTIME = 'bundler/runtime'.freeze

        def initialize(entry_hash, options = {})
          @entry_hash = entry_hash
          @options = options
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

        def top_level?
          parent.nil? || parent == BUNDLER_RUNTIME
        end

        private

        def debug_parent
          return unless @options[:debug]

          " (#{parent})"
        end
      end

      def format_list(requires_list)
        return if requires_list.size == 1

        entries = init_entries(requires_list)
        info + formatted_entries(entries)
      end

      private

      def formatted_entries(entries)
        max_indent = max_indent(entries)
        max_name_length = entries.map { |e| e.formatted_name.length }.max
        ljust_value = max_name_length + max_indent + 1

        lines = entries.reverse.map do |entry|
          indent_level = count_indent_level(entry)
          format_entry(entry, indent_level, ljust_value)
        end

        (legend(ljust_value) + lines)
      end

      def legend(ljust_value)
        [
          'name'.ljust(ljust_value + 2) + 'time' + '   RSS after',
          dash(ljust_value + 16)
        ]
      end

      def format_entry(entry, indent_level, ljust_value)
        indent = INDENT * indent_level
        time = format('%5dms', entry.time)
        rss = format('%7dKB', entry.rss)

        "#{indent}#{entry.formatted_name}".ljust(ljust_value) + time + rss
      end

      def init_entries(requires_list)
        entries = requires_list.last(requires_list.size - 1).map do |entry_hash|
          Entry.new(entry_hash, @options)
        end

        entries.select!(&:top_level?) if @options[:analyze_gemfile]

        entries
      end

      def max_indent(entries)
        entries.reverse_each { |entry| count_indent_level(entry) }
        max_indent_level = @indent_levels.map(&:values).flatten.max
        @indent_levels = []
        max_indent_level * INDENT.size
      end

      def count_indent_level(entry)
        @indent_levels ||= []
        parent_hash = @indent_levels.find { |elem| elem.key?(entry.parent) }
        parent_level = parent_hash ? parent_hash.values.first : -1
        indent_level = parent_level + 1
        @indent_levels.unshift(entry.name => indent_level)
        indent_level
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
