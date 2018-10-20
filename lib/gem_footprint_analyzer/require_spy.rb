module GemFootprintAnalyzer
  module RequireSpy
    def self.spy_require(interactor)
      Kernel.send :alias_method, :regular_require, :require

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

        if result
          interactor.report_require(name, t)
        else
          interactor.report_already_required(name)
        end
        result
      end
    end
  end
end
