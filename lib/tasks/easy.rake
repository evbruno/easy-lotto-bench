require 'pp'
require "#{Rails.root}/lib/tasks/benchmarker"

namespace :easy do

  include Benchmarker

  # BRANCHES = %w(master thin puma-w1 puma-w2)
  BRANCHES = %w(master unicorn unicorn-w2)

  desc "Fire benchmark"
  task benchmark: :environment do

    BRANCHES.each do |branch|
      b = Benchmarker::EasyBenchmark.new branch

      b.cap_deploy
      b.run_tasks
      b.cap_stop
    end

  end

  desc "Generate file reports"
  task report: :environment do


    BRANCHES.each do |branch|
      b = Benchmarker::EasyBenchmark.new branch
      parsed = Hash.new()

      b.log_files.each do |file|
        res = b.extract_results file
        puts "File: #{file}"
        pp res

        m = /.*\/results_c([0-9]+).*/.match file
        conc = m.captures[0].to_i

        parsed[conc] = res[:requests_per_second]
      end

      pp parsed

      reports_file = "#{b.output_dir}/#{branch}.dat"

      File.open(reports_file, 'w') do |file|
        parsed.sort.to_h.each_pair do |key, value|
          file.write "#{key}  #{value || 0}\n"
        end
      end
      puts "#{reports_file} done."
    end

  end

end
