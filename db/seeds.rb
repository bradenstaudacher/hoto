# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

game_id_counter = 1

7.times do 
  
  Game.create(turnstate: "white", active: true)

  counter = 1

  while counter <= 5
    i = 1
    while i <= 5
      Square.create(x: i, y: counter, height: 0, game_id: game_id_counter, colour: 'empty')
      i += 1
    end
    counter += 1
  end

  game_id_counter += 1
end