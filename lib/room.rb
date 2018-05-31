module Room
  TOKENS = [' ', '▓']
  VOID = 0
  LAND = 1

  ##
  # r - int, number of rectangles to add
  # wr - Range, width range
  # hr - Range, height range
  # xr - Range, possible x offsets
  # yr - Range, possible y offsets
  def self.gen(r, wr, hr, xr, yr)
    room = rect(rand(wr), rand(hr))

    (r - 1).times do |i|
      room2 = rect(rand(wr), rand(hr))
      room = place(
        :merge,
        room,
        room2,
        room[0] - rand(xr),
        room[1] - rand(yr)
      )
    end

    room
  end

  # Join r1 and r2 along the specified edge.
  def self.join(r1, edge, r2)
    case edge
    when :north
      shift = Row.midpoint(Row.longest_wall(north_edge(r1))) - Row.midpoint(Row.longest_wall(south_edge(r2)))
      place(:merge, r1, r2, shift, -r2[1] + 2)
    when :east
      shift = Row.midpoint(Row.longest_wall(east_edge(r1))) - Row.midpoint(Row.longest_wall(west_edge(r2)))
      place(:merge, r1, r2, r1[0] - 2, shift)
    when :south
      shift = Row.midpoint(Row.longest_wall(south_edge(r1))) - Row.midpoint(Row.longest_wall(north_edge(r2)))
      place(:merge, r1, r2, shift, r1[1] - 2)
    when :west
      shift = Row.midpoint(Row.longest_wall(west_edge(r1))) - Row.midpoint(Row.longest_wall(east_edge(r2)))
      place(:merge, r1, r2, -r2[0] + 2, shift)
    end
  end

  # Takes a room and returns the row along its northern edge
  def self.north_edge(r)
    r[2..-1].each_slice(r[0]).first
  end

  # Takes a room and returns the row along its east edge.
  def self.east_edge(r)
    r[2..-1].each_slice(r[0]).collect{|row| row[-1] }
  end

  # Takes a room and returns the row along its south edge.
  def self.south_edge(r)
    r[-r[0]..-1]
  end

  # Takes a room and returns the row along its west edge.
  def self.west_edge(r)
    r[2..-1].each_slice(r[0]).collect{|row| row[0] }
  end

  # Prints a room to STDOUT.
  def self.dump(room)
    w, h = room[0..1]
    room[2..-1].each_slice(w) do |row|
      row.each do |cell|
        print TOKENS[cell]
      end
      puts
    end
  end

  # Creates a rectangle of the specified width and height.
  def self.rect(w, h)
    r = [w, h]
    r << [LAND] * w
    (h - 2).times{ r << [1, [LAND] * (w - 2), 1] }
    r << [LAND] * w
    r.flatten
  end

  # Places r2 into/onto r1, at coordinates (x, y) relative to r1's
  # top-left corner, using the specified operation (:merge, or
  # :overwrite).
  def self.place(op, r1, r2, x, y)
    fw, fh = r1[0..1]
    rw, rh = r2[0..1]

    new_r1 = expand(copy(r1), r2, x, y)
    new_fw, new_fh = new_r1[0..1]

    x = [0, x].max
    y = [0, y].max
    r2[2..-1].each_slice(rw) do |r2_row|
      i = 2 + (y * new_fw) + x
      r1_range = i..(i + rw - 1)
      r1_row = new_r1[r1_range]
      new_r1[r1_range] = merge(r1_row, r2_row)

      y = y + 1
    end

    new_r1
  end

  # Merges r2 on top of r1, where the largest value wins.
  def self.merge(r1, r2)
    r1.map.with_index{|c, i| [c, r2[i]].max }
  end

  # Horizontally flips the room.
  def self.hflip(room)
    rw, rh = room[0..1]

    new_room = room[2..-1].each_slice(rw).map{|row| row.reverse}
    new_room.unshift([rw, rh]).flatten
  end

  # Vertically flips the room.
  def self.vflip(room)
    transpose(hflip(transpose(room)))
  end

  # Transposes rows to columns along the top-left-to-bottom-right axis
  def self.transpose(room)
    rw, rh = room[0..1]

    new_room = room[2..-1].each_slice(rw).map{|row| row}.transpose.unshift([rh, rw]).flatten
  end

  # Cross transpose rows to columns along the top-right-to-bottom-left axis
  def self.xtranspose(room)
    hflip(transpose(hflip(room)))
  end

  def self.expand(r1, r2, x, y)
    fw, fh = r1[0..1]
    rw, rh = r2[0..1]
    new_r1 = copy(r1)

    (new_r1 = pad_lft(new_r1, -x))          if x < 0
    (new_r1 = pad_rgt(new_r1, x - fw + rw)) if x + rw > fw
    (new_r1 = pad_top(new_r1, -y))          if y < 0
    (new_r1 = pad_bot(new_r1, y - fh + rh)) if y + rh > fh

    new_r1
  end

  # Removes padding from all four sides, leaving a room that fills the smallest
  # rectangle dimensions possible.
  def self.trim(room)
    nr = copy(room)

    nr = del_lft(nr) while empty_lft?(nr)
    nr = del_rgt(nr) while empty_rgt?(nr)
    nr = del_top(nr) while empty_top?(nr)
    nr = del_bot(nr) while empty_bot?(nr)

    nr
  end

  # Creates a complete, deep copy of a room.
  def self.copy(room)
    Marshal.load(Marshal.dump(room))
  end

  # Adds padding to the top, right, bottom, and left edges. Padding of 0 adds no
  # padding to the specified side.
  def self.pad(room, t, r, b, l)
    pad_top(
      pad_rgt(
        pad_bot(
          pad_lft(room, l),
          b
        ),
        r
      ),
      t
    )
  end

  # Add padding only to the left side.
  def self.pad_lft(room, count)
    new_room = []
    orig_fw = room[0]
    new_fw = orig_fw + count
    new_fh = room[1]

    room[2..-1].each_slice(orig_fw){|row| new_room << ([VOID] * count) + row }

    new_room.unshift([new_fw, new_fh])
    new_room.flatten
  end

  # Add padding only to the right side.
  def self.pad_rgt(room, count)
    new_room = []
    orig_fw = room[0]
    new_fw = orig_fw + count
    new_fh = room[1]

    room[2..-1].each_slice(orig_fw){|row| new_room << row + ([VOID] * count) }

    new_room.unshift([new_fw, new_fh])
    new_room.flatten
  end

  # Add padding only to the top side.
  def self.pad_top(room, count)
    new_room = []
    new_fw = room[0]
    new_fh = room[1] + count
    new_row = [VOID] * new_fw

    new_room << new_row * count
    room[2..-1].each_slice(new_fw){|row| new_room << row }

    new_room.unshift([new_fw, new_fh])
    new_room.flatten
  end

  # Add padding only to the bottom side.
  def self.pad_bot(room, count)
    new_room = []
    new_fw = room[0]
    new_fh = room[1] + count
    new_row = [VOID] * new_fw

    room[2..-1].each_slice(new_fw){|row| new_room << row }
    new_room << new_row * count

    new_room.unshift([new_fw, new_fh])
    new_room.flatten
  end

  # Delete the entire left column.
  def self.del_lft(room)
    rw, rh = room[0..1]
    new_room = []

    room[2..-1].each_slice(rw) do |row|
      new_room << row[1..-1]
    end

    new_room.unshift([rw - 1, rh]).flatten
  end

  # Delete the entire right column.
  def self.del_rgt(room)
    rw, rh = room[0..1]
    new_room = []

    room[2..-1].each_slice(rw) do |row|
      new_room << row[0..-2]
    end

    new_room.unshift([rw - 1, rh]).flatten
  end

  # Delete the entire top row.
  def self.del_top(room)
    rw, rh = room[0..1]
    [[rw, rh - 1], room[(2 + rw)..-1]].flatten
  end

  # Delete the entire bottom row.
  def self.del_bot(room)
    rw, rh = room[0..1]
    [[rw, rh - 1], room[2..(-rw - 1)]].flatten
  end

  # Is the left column made of only emptiness?
  def self.empty_lft?(room)
    rw = room[0]
    room[2..-1].each_slice(rw).all?{|row| row[0] == VOID }
  end

  # Is the right column made of only emptiness?
  def self.empty_rgt?(room)
    rw = room[0]
    room[2..-1].each_slice(rw).all?{|row| row[-1] == VOID }
  end

  # Is the top row made of only emptiness?
  def self.empty_top?(room)
    rw = room[0]
    room[2..-1].each_slice(rw).first.all?{|cell| cell == VOID }
  end

  # Is the bottom row made of only emptiness?
  def self.empty_bot?(room)
    rw = room[0]
    room[-rw..-1].all?{|cell| cell == VOID }
  end
end
