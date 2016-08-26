module Benchmarker

  BENCHMARK_CONCURRENCY = 1..24
  BENCHMARK_REQUESTS    = 1000
  REQUEST_TIME          = '30s'

  CONTAINER_PORT        = 8080
  SERVER_URL            = "http://127.0.0.1:#{CONTAINER_PORT}"
  OUTPUT_DIR            = '.data'

  class EasyBenchmark

    @@regex_num = '[\d]*\.?[\d]+'

    attr_reader :branch_name

    def initialize branch
      @branch_name = branch

      if @branch_name.nil? || @branch_name.empty?
        abort "Invalid arguments... missing `branch` argument"
      end

      puts "Benchmarker::EasyBenchmark #{@branch_name}"
      puts " .. pwd = #{Dir.pwd}"
    end

    def output_dir
      out = "#{OUTPUT_DIR}-#{@branch_name}"

      if ! Dir.exists? out
        puts " .. creating dir: [#{out}]"
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

    def execute cmd, sleep_for = 16
      puts "> Running: #{cmd}"
      puts `#{cmd}`
      if !$?.success?
        abort "Error: #{$?}"
      end
      sleep sleep_for
    end

    def run_tasks
      run_tasks_with_wrk
    end

    def run_tasks_with_wrk
      BENCHMARK_CONCURRENCY.each do |c|
        t = c < 8 ? c : 8
        output = "#{output_dir}/results_c#{c}_task1.log"
        cmd = "wrk -t#{t} -c#{c} -d#{REQUEST_TIME} #{SERVER_URL}/benchmarks/task1 | tee #{output}"
        execute cmd
      end
    end

    def run_tasks_with_ab
      BENCHMARK_CONCURRENCY.each do |c|
        output = "#{output_dir}/results_c#{c}_task1.log"
        cmd = "ab -n #{BENCHMARK_REQUESTS} -c #{c} #{SERVER_URL}/benchmarks/task1 | tee #{output}"
        execute cmd
      end
    end

    def cap_deploy
      raw_branch = @branch_name
      start_cmd = nil

      matching = /^(puma|unicorn)(\-w([\d]+))?$/.match @branch_name
      if matching
        raw_branch = matching.captures[0]
        workers = matching.captures[2] || 1
        puts " .. deploying #{raw_branch} w: #{workers}"
        start_cmd = "cap production easy:start_#{raw_branch} WORKERS=#{workers}"
      else
        puts " .. deploying #{@branch_name}"
        start_cmd = "cap production easy:start"
      end

      execute "cap production deploy BRANCH=#{raw_branch}", 1
      execute start_cmd, 20
    end

    def cap_stop
      puts " .. cap stop #{@branch_name}"
      execute "cap production easy:stop"
    end

  end

end
