module Generate
  module Room
    def self.rect(w, h)
      r = [w, h]
      r << [1] * w
      (h - 2).times{ r << [1, [0] * (w - 2), 1] }
      r << [1] * w
      r.flatten
    end

    def self.place(op, floor, room, x, y)
      fw, fh = floor[0..1]
      rw, rh = room[0..1]

      new_floor = expand(copy(floor), room, x, y)
      new_fw, new_fh = new_floor[0..1]

      x = [0, x].max
      y = [0, y].max
      room[2..-1].each_slice(rw) do |room_row|
        i = 2 + (y * new_fw) + x
        floor_range = i..(i + rw - 1)
        floor_row = new_floor[floor_range]
        new_floor[floor_range] = Merger.send(op, floor_row, room_row)
        y = y + 1
      end

      new_floor
    end

    def self.expand(floor, room, x, y)
      fw, fh = floor[0..1]
      rw, rh = room[0..1]
      new_floor = copy(floor)

      (new_floor = pad_lft(new_floor, -x))          if x < 0
      (new_floor = pad_rgt(new_floor, x - fw + rw)) if x + rw > fw
      (new_floor = pad_top(new_floor, -y))          if y < 0
      (new_floor = pad_bot(new_floor, y - fh + rh)) if y + rh > fh

      new_floor
    end

    def self.copy(floor)
      Marshal.load(Marshal.dump(floor))
    end

    def self.pad(floor, t, r, b, l)
      pad_top(
        pad_rgt(
          pad_bot(
            pad_lft(floor, l),
            b
          ),
          r
        ),
        t
      )
    end

    def self.pad_lft(floor, count)
      new_floor = []
      orig_fw = floor[0]
      new_fw = orig_fw + count
      new_fh = floor[1]

      floor[2..-1].each_slice(orig_fw){|row| new_floor << ([-1] * count) + row }

      new_floor.unshift([new_fw, new_fh])
      new_floor.flatten
    end

    def self.pad_rgt(floor, count)
      new_floor = []
      orig_fw = floor[0]
      new_fw = orig_fw + count
      new_fh = floor[1]

      floor[2..-1].each_slice(orig_fw){|row| new_floor << row + ([-1] * count) }

      new_floor.unshift([new_fw, new_fh])
      new_floor.flatten
    end

    def self.pad_top(floor, count)
      new_floor = []
      new_fw = floor[0]
      new_fh = floor[1] + count
      new_row = [-1] * new_fw

      new_floor << new_row * count
      floor[2..-1].each_slice(new_fw){|row| new_floor << row }

      new_floor.unshift([new_fw, new_fh])
      new_floor.flatten
    end

    def self.pad_bot(floor, count)
      new_floor = []
      new_fw = floor[0]
      new_fh = floor[1] + count
      new_row = [-1] * new_fw

      floor[2..-1].each_slice(new_fw){|row| new_floor << row }
      new_floor << new_row * count

      new_floor.unshift([new_fw, new_fh])
      new_floor.flatten
    end
  end
end
