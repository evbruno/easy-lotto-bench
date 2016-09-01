require 'pp'
require "#{Rails.root}/lib/tasks/benchmarker"

namespace :easy do

  include Benchmarker

  BRANCHES = %w(master thin puma puma-w2 puma-w3 puma-w4 unicorn unicorn-w2 unicorn-w3 unicorn-w4 passenger)
  # BRANCHES = %w(master thin puma puma-w2 puma-w3 puma-w4 unicorn)
  # BRANCHES = %w(master thin puma puma-w2 unicorn unicorn-w2 passenger)

  desc "Fire benchmark"
  task benchmark: :environment do

    BRANCHES.each do |branch|
      b = EasyBenchmark.new branch

      b.cap_deploy
      b.run_tasks
      b.cap_stop
    end

  end

  desc "Generate file reports (using wrk)"
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

  desc "Generate file reports (using ab)"
  task report_ab: :environment do

    parsed_all = Hash.new

    BRANCHES.each do |branch|
      b = EasyBenchmark.new branch
      parsed = b.parse_results_ab
      parsed_all[branch] = parsed

      reports_file = "#{b.output_dir}/#{branch}.dat"
      b.write_result reports_file, parsed
    end

    EasyBenchmark.gen_markdown_table parsed_all

  end

  desc "Fire benchmark on Heroku (wrk)"
  task bench_heroku: :environment do

    start = Time.now

    BRANCHES.each do |branch|
      b = EasyBenchmark.new branch
      b.push_branch
      b.run_tasks
    end

    puts
    puts "> Finished !"
    puts "> Took #{Time.now - start} seconds..."
    puts

  end

  desc "Fire benchmark on Heroku (ab)"
  task bench_ab_heroku: :environment do

    start = Time.now

    BRANCHES.each do |branch|
      b = EasyBenchmark.new branch
      b.push_branch
      b.run_tasks_with_ab
    end

    puts
    puts "> Finished !"
    puts "> Took #{Time.now - start} seconds..."
    puts

  end

end
