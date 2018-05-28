module Room
  ##
  # r - int, number of rectangles to add
  # wr - Range, width range
  # hr - Range, height range
  # j - int, jitter (how far off center to place each rect)
  def self.gen(r, wr, hr, j)
    room = rect(rand(wr), rand(hr))

    (r - 1).times do |i|
      room_2 = rect(rand(wr), rand(hr))
      room = place(
        :merge,
        room,
        room_2,
        rand(-j..j),
        rand(-j..j)
      )
    end

    room
  end

  def self.rect(w, h)
    r = [w, h]
    r << [1] * w
    (h - 2).times{ r << [1, [0] * (w - 2), 1] }
    r << [1] * w
    r.flatten
  end

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
      new_r1[r1_range] = Merger.send(op, r1_row, r2_row)
      y = y + 1
    end

    new_r1
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

  def self.trim(room)
    nr = copy(room)

    nr = del_lft(nr) while empty_lft?(nr)
    nr = del_rgt(nr) while empty_rgt?(nr)
    nr = del_top(nr) while empty_top?(nr)
    nr = del_bot(nr) while empty_bot?(nr)

    nr
  end

  def self.copy(room)
    Marshal.load(Marshal.dump(room))
  end

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

  def self.pad_lft(room, count)
    new_room = []
    orig_fw = room[0]
    new_fw = orig_fw + count
    new_fh = room[1]

    room[2..-1].each_slice(orig_fw){|row| new_room << ([-1] * count) + row }

    new_room.unshift([new_fw, new_fh])
    new_room.flatten
  end

  def self.pad_rgt(room, count)
    new_room = []
    orig_fw = room[0]
    new_fw = orig_fw + count
    new_fh = room[1]

    room[2..-1].each_slice(orig_fw){|row| new_room << row + ([-1] * count) }

    new_room.unshift([new_fw, new_fh])
    new_room.flatten
  end

  def self.pad_top(room, count)
    new_room = []
    new_fw = room[0]
    new_fh = room[1] + count
    new_row = [-1] * new_fw

    new_room << new_row * count
    room[2..-1].each_slice(new_fw){|row| new_room << row }

    new_room.unshift([new_fw, new_fh])
    new_room.flatten
  end

  def self.pad_bot(room, count)
    new_room = []
    new_fw = room[0]
    new_fh = room[1] + count
    new_row = [-1] * new_fw

    room[2..-1].each_slice(new_fw){|row| new_room << row }
    new_room << new_row * count

    new_room.unshift([new_fw, new_fh])
    new_room.flatten
  end

  def self.del_lft(room)
    rw, rh = room[0..1]
    new_room = []

    room[2..-1].each_slice(rw) do |row|
      new_room << row[1..-1]
    end

    new_room.unshift([rw - 1, rh]).flatten
  end

  def self.del_rgt(room)
    rw, rh = room[0..1]
    new_room = []

    room[2..-1].each_slice(rw) do |row|
      new_room << row[0..-2]
    end

    new_room.unshift([rw - 1, rh]).flatten
  end

  def self.del_top(room)
    rw, rh = room[0..1]
    [[rw, rh - 1], room[(2 + rw)..-1]].flatten
  end

  def self.del_bot(room)
    rw, rh = room[0..1]
    [[rw, rh - 1], room[2..(-rw - 1)]].flatten
  end

  def self.empty_lft?(room)
    rw = room[0]
    room[2..-1].each_slice(rw).all?{|row| row[0] == -1 }
  end

  def self.empty_rgt?(room)
    rw = room[0]
    room[2..-1].each_slice(rw).all?{|row| row[-1] == -1 }
  end

  def self.empty_top?(room)
    rw = room[0]
    room[2..-1].each_slice(rw).first.all?{|cell| cell == -1 }
  end

  def self.empty_bot?(room)
    rw = room[0]
    room[-rw..-1].all?{|cell| cell == -1 }
  end
end
