module GemFootprintAnalyzer
  module RequireSpy
    def self.relative_path(caller_entry, require_name=nil)
      caller_file = caller_entry.split(':')[0]
      if require_name
        caller_dir = File.dirname(caller_file)
        full_path = File.join(caller_dir, require_name)
      else
        full_path = caller_file
      end
      load_path = $LOAD_PATH.find { |lp| full_path.start_with?(lp) }
      full_path.sub(/\A#{load_path}\//, '')
    end

    def self.first_foreign_caller(caller)
      ffc = caller.find { |c| GemFootprintAnalyzer::RequireSpy.relative_path(c) !~ /gem_footprint_analyzer/ }
      if ffc
        GemFootprintAnalyzer::RequireSpy.relative_path(ffc).sub(/\.rb\z/, '')
      end
    end

    def self.spy_require(interactor)
      Kernel.send :alias_method, :regular_require, :require
      Kernel.send :alias_method, :regular_require_relative, :require_relative

      Kernel.send :define_method, :timed_exec do |&block|
        start_time = Time.now.to_f
        block.call
        (Time.now.to_f - start_time).round(4)
      end

      Kernel.send :define_method, :require do |name|
        result = nil

        interactor.ready
        interactor.wait_for_start

        t = timed_exec do
          result = regular_require(name)
        end
        first_foreign_caller = GemFootprintAnalyzer::RequireSpy.first_foreign_caller(caller)
        interactor.report_require(name, first_foreign_caller || '', t)
        result
      end

      # As of Ruby 2.5.1, both :require and :require_relative use an unexposed
      # native method rb_safe_require, however it's challenging to plug into it
      # and using original :require_relative is not really possible (it does path calculation magic)
      # so instead we're redirecting :require_relative to the regular :require
      Kernel.send :define_method, :require_relative do |name|
        relative_path = GemFootprintAnalyzer::RequireSpy.relative_path(caller[0], name)
        return require(relative_path)
      end
    end
  end
end
