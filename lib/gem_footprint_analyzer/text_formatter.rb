module GemFootprintAnalyzer
  class TextFormatter
    TABULATION = '  '.freeze
    NEWLINE = "\n".freeze

    def format(requires_list)
      return if requires_list.size == 1
      entries_num = requires_list.size
      lines = []
      longest_name_length = requires_list.map { |el| el[:name]&.length }.compact.max

      lines << [format_name('name', longest_name_length, false), '  time  ', 'RSS after'].join(' ')
      lines << dash(longest_name_length) if requires_list.size > 2

      requires_list.each_with_index do |entry, i|
        next if i.zero?

        last_element = (i == entries_num - 1)

        name, time, rss = entry.values_at(:name, :time, :rss)
        lines << dash(longest_name_length) if last_element
        lines << [format_name(name, longest_name_length, last_element), format_time(time), format_rss(rss)].join(' ')
      end
      lines.join(NEWLINE)
    end

    private

    def format_name(name, longest_name_length, last_element = false)
      left_just_size = longest_name_length + 3
      left_just_size += TABULATION.size if last_element
      tabulation = last_element ? '' : TABULATION
      tabulation + name.ljust(left_just_size)
    end

    def format_time(time)
      value = time.is_a?(Hash) ? time[:mean] : time
      "%4dms" % value.round
    end

    def format_rss(rss)
      value = rss.is_a?(Hash) ? rss[:mean] : rss
      "%6dKB" % value
    end

    def dash(longest_name_length)
      '-' * (longest_name_length + 22)
    end
  end
end