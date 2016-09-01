require 'matrix'
require 'fileutils'

module Benchmarker

  BENCHMARK_CONCURRENCY = 1..30
  BENCHMARK_REQUESTS    = (ENV['REQUEST_TIME'] || 1000).to_i
  REQUEST_TIME          = ENV['REQUEST_TIME'] || '30s'
  SERVER_URL            = ENV['SERVER_URL']   || 'http://127.0.0.1:8080'
  OUTPUT_DIR            = ENV['OUTPUT_DIR']   || '.benchmarks/data'
  AVAILABLE_TASKS       = 2
  TASK_TO_REPORT        = ENV['TASK'] || '1'

  class EasyBenchmark

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
        FileUtils.mkdir_p out
      end

      out
    end

    def execute cmd, sleep_for = 16
      puts "> Running: #{cmd} (sleeping: #{sleep_for})"
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

        1.upto(AVAILABLE_TASKS) do | task |

          output = "#{output_dir}/results_c#{c}_task#{task}.log"
          cmd = "wrk -t#{t} -c#{c} -d#{REQUEST_TIME} #{SERVER_URL}/benchmarks/task#{task} | tee #{output}"
          execute cmd

        end
      end
    end

    def run_tasks_with_ab
      BENCHMARK_CONCURRENCY.each do |c|
        1.upto(AVAILABLE_TASKS) do | task |

          output = "#{output_dir}/results_c#{c}_task#{task}.log"
          cmd = "ab -n #{BENCHMARK_REQUESTS} -c #{c} #{SERVER_URL}/benchmarks/task#{task} | tee #{output}"
          execute cmd
        end
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
      elsif @branch_name == 'passenger'
        puts " .. deploying #{@branch_name}"
        start_cmd = "cap production easy:start_passenger"
      else
        puts " .. deploying #{@branch_name}"
        start_cmd = "cap production easy:start"
      end

      execute "cap production deploy BRANCH=#{raw_branch}", 1
      execute start_cmd, 20

      cmd = "curl -q 'http://localhost:8081/benchmarks/task1' &> /dev/null"
      puts `#{cmd}`
      if !$?.success?
        puts "ISN'T Running !!!"
        puts " >>> Trying to stop/start once more..."

        cap_stop
        execute start_cmd, 20
      end
    end

    def cap_stop
      puts " .. cap stop #{@branch_name}"
      execute "cap production easy:stop"
    end

    ### reports

    def log_files
      Dir["#{output_dir}/*task#{TASK_TO_REPORT}.log"]
    end

    def extract_results file_name
      extract_results_for_wrk file_name
    end

    def extract_results_for_wrk file_name
      text = File.read file_name

      # m0 = /Req\/Sec\s*([\d]*\.?[\d]+)\s*([\d]*\.?[\d]+)\s*([\d]*\.?[\d]+)\s*([\d]*\.?[\d]+)%/.match text
      m0 = /Req\/Sec\s*([\d]*\.?[\d]+)\s*([\d]*\.?[\d]+)\s*([\d]*\.?[\d]+)\s*(([\d]*\.?[\d]+)|nan)%/.match text
      ret = Hash.new()

      ret[:request_per_sec_avg]   = m0.captures[0]
      ret[:request_per_sec_stdev] = m0.captures[1]
      ret[:request_per_sec_max]   = m0.captures[2]
      ret[:request_per_sec_perc]  = m0.captures[3]

      # m1 = /Latency\s*([\d]*\.?[\d]+)ms\s*([\d]*\.?[\d]+)ms\s*([\d]*\.?[\d]+)ms\s*([\d]*\.?[\d]+)%/.match text
      # ret[:latency_avg]   = m1.captures[0]
      # ret[:latency_stdev] = m1.captures[1]
      # ret[:latency_max]   = m1.captures[2]
      # ret[:latency_perc]  = m1.captures[3]

      ret[:requests_per_second] = text[/Requests\/sec:\s*([\d]*\.?[\d]+).*/, 1]
      ret[:transfer_rate]       = text[/Transfer\/sec:\s*([\d]*\.?[\d]+).*/, 1]

      ret
    end

    def parse_results
      parsed = Hash.new()

      log_files.each do |file|
        res = extract_results file
        puts "File: #{file}"
        conc = (file[/.*\/results_c([0-9]+).*/, 1]).to_i

        parsed[conc] = res[:requests_per_second]
      end

      parsed.sort.to_h
    end

    def extract_results_for_ab file_name
      text = File.read file_name
      ret = Hash.new()

      ret[:requests_per_second] = text[/Requests per second:\s*([\d]*\.?[\d]+).*/, 1]
      ret[:transfer_rate]       = text[/Transfer rate:\s*([\d]*\.?[\d]+).*/, 1]
      ret[:time_per_requests]   = text[/Time per request:\s*([\d]*\.?[\d]+).*concurrent requests\)/, 1]
      ret[:complete_requests]   = text[/Complete requests:\s*([\d]*\.?[\d]+).*/, 1]
      ret[:failed_requests]     = text[/Failed requests:\s*([\d]*\.?[\d]+).*/, 1]
      ret
    end

    def parse_results_ab
      parsed = Hash.new()

      log_files.each do |file|
        res = extract_results_for_ab file
        puts "File: #{file}"
        conc = (file[/.*\/results_c([0-9]+).*/, 1]).to_i

        parsed[conc] = res[:requests_per_second]
      end

      parsed.sort.to_h
    end

    def write_result reports_file, parsed
      File.open(reports_file, 'w') do |file|
        parsed.each_pair do |key, value|
          file.write "#{key}  #{value || 0}\n"
        end
      end
      puts "#{reports_file} done."
    end

    def self.gen_markdown_table parsed_all
      headers = parsed_all.keys
      headers.unshift "conc."

      col_len = headers.map{|k| k.length}.sort.last + 1

      grid = Matrix.build(BENCHMARK_CONCURRENCY.size + 2, headers.size) { |r, c|
        h = headers[c]
        if r == 0     ; "| " + h.center(col_len)
        elsif r == 1  ; "|"  + "-".ljust(col_len + 1, '-')
        elsif c == 0  ; "| " + (r - 1).to_s.center(col_len)
        else          ; "| " + parsed_all[h][r - 1].to_s.center(col_len)
        end
      }

      puts "> Printing mardkown table"
      grid.to_a.each do |row|
        row.each { |col| print col }
        puts "|"
      end

    end

    def push_branch
      cmd = "git push -f heroku #{@branch_name}:master"
      execute cmd, 30
      cmd = "curl #{SERVER_URL}/benchmarks/task1"
      execute cmd, 5
    end

    def self.gen_markdown_table_without_conc parsed_all
      headers = parsed_all.keys
      col_len = headers.map{|k| k.length}.sort.last + 1

      grid = Matrix.build(BENCHMARK_CONCURRENCY.size + 2, headers.size) { |r, c|
        h = headers[c]
        if r == 0     ; "| " + h.center(col_len)
        elsif r == 1  ; "|"  + "-".ljust(col_len + 1, '-')
        else          ; "| " + parsed_all[h][r - 1].to_s.center(col_len)
        end
      }

      puts "> Printing mardkown table"
      grid.to_a.each do |row|
        row.each { |col| print col }
        puts "|"
      end

    end

  end

end
