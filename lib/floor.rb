module Generate
  module Floor
    def self.place(floor, room, x, y)
      fw, fh = floor[0..1]
      rw, rh = room[0..1]

      new_floor = copy(floor)

      (new_floor = add_columns_left(new_floor, -x))           if x < 0
      (new_floor = add_columns_right(new_floor, x - fw + rw)) if x + rw > fw
      (new_floor = add_rows_top(new_floor, -y))               if y < 0
      (new_floor = add_rows_bottom(new_floor, y - fh + rh))   if y + rh > fh

      new_fw, new_fh = new_floor[0..1]

      x = [0, x].max
      y = [0, y].max

      room[2..-1].each_slice(rw) do |room_row|
        i = 2 + (y * new_fw) + x
        new_floor[i..(i + rw - 1)] = room_row
        y = y + 1
      end

      new_floor
    end

    def self.copy(floor)
      Marshal.load(Marshal.dump(floor))
    end

    def self.add_columns_left(floor, count)
      new_floor = []
      orig_fw = floor[0]
      new_fw = orig_fw + count
      new_fh = floor[1]

      floor[2..-1].each_slice(orig_fw){|row| new_floor << ([-1] * count) + row }

      new_floor.unshift([new_fw, new_fh])
      new_floor.flatten
    end

    def self.add_columns_right(floor, count)
      new_floor = []
      orig_fw = floor[0]
      new_fw = orig_fw + count
      new_fh = floor[1]

      floor[2..-1].each_slice(orig_fw){|row| new_floor << row + ([-1] * count) }

      new_floor.unshift([new_fw, new_fh])
      new_floor.flatten
    end

    def self.add_rows_top(floor, count)
      new_floor = []
      new_fw = floor[0]
      new_fh = floor[1] + count
      new_row = [-1] * new_fw

      new_floor << new_row * count
      floor[2..-1].each_slice(new_fw){|row| new_floor << row }

      new_floor.unshift([new_fw, new_fh])
      new_floor.flatten
    end

    def self.add_rows_bottom(floor, count)
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
