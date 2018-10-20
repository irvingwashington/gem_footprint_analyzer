module GemFootprintAnalyzer
  class AverageRunner
    RUNS = 10
    AVERAGED_FIELDS = %i[rss time]

    def initialize(runs=RUNS, &run_block)
      fail ArgumentError, 'runs must be > 0' if runs < 1

      @run_block = run_block
      @runs = runs
    end

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
      average_results = []
      first_run = results[0]

      first_run.size.times do |require_number|
        samples = results.map { |r| r[require_number] }
        first_sample = samples.first

        average = initialize_average_with_copied_fields(first_sample)
        AVERAGED_FIELDS.map do |field|
          next unless first_sample.key?(field)

          average[field] = calculate_average(samples.map { |s| s[field] })
        end
        average_results << average
      end
      average_results
    end

    def calculate_average(values)
      num = values.size
      sum = values.sum.to_f
      mean = sum / num

      stddev = Math.sqrt(values.sum { |v| (v - mean) ** 2 } / num)
      {mean: mean, sttdev: stddev}
    end

    def initialize_average_with_copied_fields(sample)
      average = {}
      (sample.keys - AVERAGED_FIELDS).each { |k| average[k] = sample[k] }
      average
    end
  end
end
