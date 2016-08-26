module Benchmarker

  BRANCHES              = %w(puma)
  BENCHMARK_CONCURRENCY = 1..24
  BENCHMARK_REQUESTS    = 1000

  CONTAINER_PORT        = 8080
  SERVER_URL            = "http://127.0.0.1:#{CONTAINER_PORT}"
  OUTPUT_DIR            = '.data'

  class EasyBenchmark

    @@regex_num = '[\d]*\.?[\d]+'

    attr_reader :profile

    def initialize
      @profile = ENV['PROFILE']

      if @profile.nil? || @profile.empty?
        abort "Invalid arguments... missing $PROFILE"
      end

      puts "Benchmarker::EasyBenchmark #{@profile}"
      puts " ... pwd = #{Dir.pwd}"
    end

    def branches
      BRANCHES
    end

    def output_dir
      out = "#{OUTPUT_DIR}-#{@profile}"

      if ! Dir.exists? out
        puts " ... creating dir: [#{out}]"
        Dir.mkdir out
      end

      out
    end

    def log_files
      Dir["#{output_dir}/*.log"]
    end

    def extract_results file_name
      extract_results_for_wrk file_name
    end

    def extract_results_for_wrk file_name
      text = File.read file_name

      m0 = /Req\/Sec\s*(#{@@regex_num})\s*(#{@@regex_num})\s*(#{@@regex_num})\s*(#{@@regex_num})%/.match text
      ret = Hash.new()

      ret[:request_per_sec_avg]   = m0.captures[0]
      ret[:request_per_sec_stdev] = m0.captures[1]
      ret[:request_per_sec_max]   = m0.captures[2]
      ret[:request_per_sec_perc]  = m0.captures[3]

      # m1 = /Latency\s*(#{@@regex_num})ms\s*(#{@@regex_num})ms\s*(#{@@regex_num})ms\s*(#{@@regex_num})%/.match text
      # ret[:latency_avg]   = m1.captures[0]
      # ret[:latency_stdev] = m1.captures[1]
      # ret[:latency_max]   = m1.captures[2]
      # ret[:latency_perc]  = m1.captures[3]

      ret[:requests_per_second] = text[/Requests\/sec:\s*(#{@@regex_num}).*/, 1]
      ret[:transfer_rate]       = text[/Transfer\/sec:\s*(#{@@regex_num}).*/, 1]

      ret
    end

    def extract_results_for_ab file_name
      text = File.read file_name
      ret = Hash.new()

      ret[:requests_per_second] = text[/Requests per second:\s*(#{@@regex_num}).*/, 1]
      ret[:transfer_rate]       = text[/Transfer rate:\s*(#{@@regex_num}).*/, 1]
      ret[:time_per_requests]   = text[/Time per request:\s*(#{@@regex_num}).*concurrent requests\)/, 1]
      ret[:complete_requests]   = text[/Complete requests:\s*(#{@@regex_num}).*/, 1]
      ret[:failed_requests]     = text[/Failed requests:\s*(#{@@regex_num}).*/, 1]
      ret
    end

    def execute cmd
      puts "Running: #{cmd}"
      puts `#{cmd}`
      if !$?.success?
        abort "Error: #{$?}"
      end
    end

    def run_tasks
      run_tasks_with_wrk
    end

    def run_tasks_with_wrk
      BENCHMARK_CONCURRENCY.each do |c|
        t = c < 8 ? c : 8
        output = "#{output_dir}/results_c#{c}_task1.log"
        cmd = "wrk -t#{t} -c#{c} -d10s #{SERVER_URL}/benchmarks/task1 | tee #{output}"
        execute cmd
        sleep 20
      end
    end

    def run_tasks_with_ab
      BENCHMARK_CONCURRENCY.each do |c|
        output = "#{output_dir}/results_c#{c}_task1.log"
        cmd = "ab -n #{BENCHMARK_REQUESTS} -c #{c} #{SERVER_URL}/benchmarks/task1 | tee #{output}"
        execute cmd
        sleep 20
      end
    end

  end

end
