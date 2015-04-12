# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

counter = 1

while counter <= 5 
  i = 1
  while i <= 5
    Square.create(x: counter, y: i, height: 0)
    i += 1
  end
  counter += 1
end


# t.integer  "x"
#     t.integer  "y"
#     t.string   "colour"
#     t.integer  "height"
#     t.datetime "created_at"
#     t.datetime "updated_at"
#   end



  # BOARD = [
  #   ['x','x','x','x','x'],
  #   ['x','x','x','x','x'],
  #   ['x','x','x','x','x'],
  #   ['x','x','x','x','x'],
  #   ['x','x','x','x','x']
  # ] 
