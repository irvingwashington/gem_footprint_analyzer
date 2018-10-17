module RequireFootprintAnalyzer
  class TextFormatter
    TABULATION = '  '.freeze

    def format(requires_list)
      base_rss = nil
      entries_num = requires_list.size
      lines = []
      longest_name_length = requires_list.map { |el| el[:name]&.length }.compact.max

      lines << [format_name('name', longest_name_length, false), 'time    ', 'RSS after'].join(' ')
      lines << dash(longest_name_length) if requires_list.size > 2

      requires_list.each_with_index do |entry, i|
        last_element = (i == entries_num - 1)

        if i.zero?
          base_rss = entry[:rss]
          next
        end

        name, time, rss = entry.values_at(:name, :time, :rss)
        lines << dash(longest_name_length) if last_element
        lines << [format_name(name, longest_name_length, last_element), format_time(time), format_rss(rss)].join(' ')
      end
      lines.join("\n")
    end

    private

    def format_name(name, longest_name_length, last_element = false)
      left_just_size = longest_name_length + 3
      left_just_size += TABULATION.size if last_element
      tabulation = last_element ? '' : TABULATION
      tabulation + name.ljust(left_just_size)
    end

    def format_time(time)
      "%0.4fs" % time
    end

    def format_rss(rss)
      "%5dKB" % rss
    end

    def dash(longest_name_length)
      '-' * (longest_name_length + 22)
    end
  end
end