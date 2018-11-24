module GemFootprintAnalyzer
  # A module keeping hacks required to hijack {Kernel.require} and {Kernel.require_relative}
  # and plug in versions of them that communicate meta data to the {Analyzer}.
  module RequireSpy
    # Suitable for versions 3.0.stable up to 5.2.1
    ACTIVESUPPORT_REQUIRE_DEPENDENCY =
      %r{active_support/dependencies\.rb.+(`require'|`load_dependency'|`block in require')\z}.freeze

    class << self
      def relative_path(caller_entry, require_name = nil)
        caller_file = caller_entry.split(':')[0]
        if require_name
          caller_dir = File.dirname(caller_file)
          full_path = File.join(caller_dir, require_name)
        else
          full_path = caller_file
        end
        load_path = load_paths.find { |lp| full_path.start_with?(lp) }
        full_path.sub(%r{\A#{load_path}/}, '')
      end

      def load_paths
        @load_paths ||= $LOAD_PATH.map { |path| File.expand_path(path) }
      end

      def without_extension(name)
        name.sub(/\.rb\z/, '')
      end

      def first_foreign_caller(caller_list)
        ffc = caller_list.find do |c|
          c !~ ACTIVESUPPORT_REQUIRE_DEPENDENCY &&
            relative_path(c) !~ /gem_footprint_analyzer/
        end
        without_extension(relative_path(ffc)) if ffc
      end

      def spy_require(transport)
        alias_require_methods

        define_require_relatives
        define_requires(transport)
      end

      def timed_exec
        start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        result = yield
        duration = (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time).round(4)
        [duration, result]
      end

      def alias_require_methods
        kernels.each do |k|
          k.send :alias_method, :regular_require, :require
          k.send :alias_method, :regular_require_relative, :require_relative
        end
      end

      def kernels
        @kernels ||= [(class << ::Kernel; self; end), Kernel]
      end

      def define_requires(transport)
        kernels.each { |k| define_require(k, transport) }
      end

      def define_require(klass, transport)
        klass.send :define_method, :require do |name|
          transport.ready_and_wait_for_start
          duration, result = GemFootprintAnalyzer::RequireSpy.timed_exec { regular_require(name) }
          bare_name = GemFootprintAnalyzer::RequireSpy.relative_path(name)

          transport.report_require(GemFootprintAnalyzer::RequireSpy.without_extension(bare_name),
                                   GemFootprintAnalyzer::RequireSpy.first_foreign_caller(caller),
                                   duration)

          result
        end
      end

      def define_require_relatives
        # As of Ruby 2.5.1, both :require and :require_relative use an unexposed native method
        # rb_safe_require, however it's challenging to plug into it and using original
        # :require_relative is not really possible (it does path calculation magic) so instead
        # we're redirecting :require_relative to the regular :require
        kernels.each do |k|
          k.send :define_method, :require_relative do |name|
            last_caller = caller(1..1).first
            relative_path = GemFootprintAnalyzer::RequireSpy.relative_path(last_caller, name)

            require(relative_path)
          end
        end
      end
    end
  end
end
