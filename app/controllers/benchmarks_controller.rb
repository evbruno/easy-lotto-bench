class BenchmarksController < ApplicationController

  # task1: execute 22 queries, renders json
  def task1
    request.format = :json

    task = Lottery.all.map do |l|
      h = Hash.new
      h[:lottery] = l
      h[:avg_value] = l.prizes.average(:value)
      h[:min_number] = l.draws.minimum(:number)
      h
    end

    render json: task
  end

  # TODO
  # task2: execute query, render (embedded) html
  # task3: execute 1 insert, render json
  # task4: static content (css)

end
