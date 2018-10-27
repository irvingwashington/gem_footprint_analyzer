module GemFootprintAnalyzer
  # A class handling sampling and calculating basic statistical values from the set of runs.
  class AverageRunner
    RUNS = 10
    AVERAGED_FIELDS = %i[rss time].freeze

    # @param runs [Integer] optional number of runs to perform
    # @param run_block [proc] actual unit of work to be done runs times
    def initialize(runs = RUNS, &run_block)
      raise ArgumentError, 'runs must be > 0' unless runs > 0

      @run_block = run_block
      @runs = runs
    end

    # @return [Array<Hash>] Array of hashes that now include average metrics in place of fields
    #   present in {AVERAGED_FIELDS}. The rest of the columns is copied from the first sample.
    def run
      results = []
      @runs.times do
        results << run_once
      end
      calculate_averages(results)
    end

    private

    def run_once
      @run_block.call
    end

    # Take corresponding results array values and compare them
    def calculate_averages(results)
      Array.new(results.first.size) do |require_number|
        samples = results.map { |r| r[require_number] }
        first_sample = samples.first

        average = initialize_average_with_copied_fields(first_sample)
        AVERAGED_FIELDS.map do |field|
          next unless first_sample.key?(field)

          average[field] = calculate_average(samples.map { |s| s[field] })
        end
        average
      end
    end

    def calculate_average(values)
      num = values.size
      sum = values.sum.to_f
      mean = sum / num

      stddev = Math.sqrt(values.sum { |v| (v - mean)**2 } / num)
      {mean: mean, sttdev: stddev}
    end

    def initialize_average_with_copied_fields(sample)
      average = {}
      (sample.keys - AVERAGED_FIELDS).each { |k| average[k] = sample[k] }
      average
    end
  end
end
