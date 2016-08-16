# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Prize.destroy_all
# Draw.destroy_all
# Game.destroy_all
Lottery.destroy_all

10.times do
  name = Faker::Name.name
  lottery = Lottery.create! name: name, abbrev: name, source_url: Faker::Internet.url

  100.times do |a|
    game = lottery.games.create! draw_date: DateTime.now - a
    5.times do |b|
      game.prizes.create! hits: (b+1), value: Faker::Number.decimal(10, 1)
      game.draws.create! number: Faker::Number.between(1, 50)
    end
  end
end

