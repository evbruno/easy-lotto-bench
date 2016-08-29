require 'pp'
require "#{Rails.root}/lib/tasks/benchmarker"

namespace :easy do

  include Benchmarker

  BRANCHES = %w(master thin puma-w1 puma-w2 unicorn unicorn-w2)

  desc "Fire benchmark"
  task benchmark: :environment do

    BRANCHES.each do |branch|
      b = EasyBenchmark.new branch

      b.cap_deploy
      b.run_tasks
      b.cap_stop
    end

  end

  desc "Generate file reports"
  task report: :environment do

    parsed_all = Hash.new

    BRANCHES.each do |branch|
      b = EasyBenchmark.new branch
      parsed = b.parse_results
      parsed_all[branch] = parsed

      reports_file = "#{b.output_dir}/#{branch}.dat"
      b.write_result reports_file, parsed
    end

    EasyBenchmark.gen_markdown_table parsed_all

  end

end
