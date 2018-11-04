module GemFootprintAnalyzer
  # A module keeping hacks required to hijack {Kernel.require} and {Kernel.require_relative}
  # and plug in versions of them that communicate meta data to the {Analyzer}.
  module RequireSpy
    class << self
      def relative_path(caller_entry, require_name = nil)
        caller_file = caller_entry.split(':')[0]
        if require_name
          caller_dir = File.dirname(caller_file)
          full_path = File.join(caller_dir, require_name)
        else
          full_path = caller_file
        end
        load_path = $LOAD_PATH.find { |lp| full_path.start_with?(lp) }
        full_path.sub(%r{\A#{load_path}/}, '')
      end

      def first_foreign_caller(caller)
        ffc = caller.find do |c|
          GemFootprintAnalyzer::RequireSpy.relative_path(c) !~ /gem_footprint_analyzer/
        end
        GemFootprintAnalyzer::RequireSpy.relative_path(ffc).sub(/\.rb\z/, '') if ffc
      end

      def spy_require(transport)
        alias_require_methods
        define_timed_exec

        define_require_relative
        define_require(transport)
      end

      def alias_require_methods
        Kernel.send :alias_method, :regular_require, :require
        Kernel.send :alias_method, :regular_require_relative, :require_relative
      end

      def define_timed_exec
        Kernel.send :define_method, :timed_exec do |&block|
          start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          block.call
          (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time).round(4)
        end
      end

      def define_require(transport)
        Kernel.send :define_method, :require do |name|
          result = nil

          transport.ready
          transport.wait_for_start

          t = timed_exec { result = regular_require(name) }

          first_foreign_caller = GemFootprintAnalyzer::RequireSpy.first_foreign_caller(caller)
          transport.report_require(name, first_foreign_caller || '', t)
          result
        end
      end

      def define_require_relative
        # As of Ruby 2.5.1, both :require and :require_relative use an unexposed native method
        # rb_safe_require, however it's challenging to plug into it and using original
        # :require_relative is not really possible (it does path calculation magic) so instead
        # we're redirecting :require_relative to the regular :require
        Kernel.send :define_method, :require_relative do |name|
          last_caller = caller(1..1).first
          relative_path = GemFootprintAnalyzer::RequireSpy.relative_path(last_caller, name)
          return require(relative_path)
        end
      end
    end
  end
end
