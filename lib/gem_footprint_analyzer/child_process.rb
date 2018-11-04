require 'open3'
require 'rbconfig'

module GemFootprintAnalyzer
  # A class for starting the child process that does actual requires.
  class ChildProcess
    LEGACY_RUBY_CMD = [RbConfig.ruby, '--disable=gem'].freeze
    RUBY_CMD = [RbConfig.ruby, '--disable=did_you_mean', '--disable=gem'].freeze

    def initialize(library, require_string, fifos)
      @library = library
      @require_string = require_string || library
      @fifos = fifos
      @pid = nil
    end

    def start_child
      @child_thread ||= Thread.new do # rubocop:disable Naming/MemoizedInstanceVariableName
        Open3.popen3(child_env_vars, *ruby_command, context_file) do |_, stdout, stderr|
          @pid = stdout.gets.strip.to_i

          while (line = stderr.gets)
            puts "!! #{line.strip}"
          end
        end
      end
    end

    def pid
      return unless child_thread

      sleep 0.01 while @pid.nil?
      @pid
    end

    private

    attr_reader :require_string, :child_thread, :fifos

    def ruby_command
      if RbConfig::CONFIG['MAJOR'].to_i >= 2 && RbConfig::CONFIG['MINOR'].to_i >= 3
        RUBY_CMD
      else
        LEGACY_RUBY_CMD
      end
    end

    def child_env_vars
      {
        'require_string' => require_string,
        'start_child_context' => 'true',
        'child_fifo' => fifos[:child],
        'parent_fifo' => fifos[:parent],
        'RUBYOPT' => '', # Stop bundler from requiring bundler/setup
        'RUBYLIB' => $LOAD_PATH.join(':') # Include bundler-provided paths and paths passed by user
      }
    end

    def context_file
      File.join(__dir__, 'child_context.rb')
    end
  end
end
