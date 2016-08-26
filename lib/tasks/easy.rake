require 'pp'
require "#{Rails.root}/lib/tasks/benchmarker"

namespace :easy do

  include Benchmarker

  desc "Fire benchmark"
  task benchmark: :environment do
    b = Benchmarker::EasyBenchmark.new

    b.branches.each { |branch|
      b.run_tasks
    }

  end

  desc "Generate file reports"
  task report: :environment do
    b = Benchmarker::EasyBenchmark.new
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

    reports_file = "#{b.output_dir}/#{b.profile}.dat"

    File.open(reports_file, 'w') do |file|
      parsed.sort.to_h.each_pair do |key, value|
        file.write "#{key}  #{value || 0}\n"
      end
    end
    puts "#{reports_file} done."
  end

end
