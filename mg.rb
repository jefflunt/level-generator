$LOAD_PATH.unshift 'lib'
require 'room'
require 'row'

nw = Room.gen(10, 3..9, 3..9, 2..12, 3..12)
ne = Room.gen(10, 3..9, 3..9, 2..12, 3..12)
sw = Room.gen(10, 3..9, 3..9, 2..12, 3..12)
se = Room.gen(10, 3..9, 3..9, 2..12, 3..12)

Room.dump(nw)
puts "\n---\n\n"
Room.dump(ne)
puts "\n---\n\n"
Room.dump(sw)
puts "\n---\n\n"
Room.dump(se)
puts "\n---\n\n"

Room.dump(
  Room.join(
    Room.join(nw, :rgt, ne),
    :bot,
    Room.join(sw, :rgt, se)
  )
)
