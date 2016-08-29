class BenchmarksController < ApplicationController

  # task1: execute a lot of queries, renders json
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

  def task2
    @lotteries = Lottery.all
    render 'lotteries/index'
  end

end
