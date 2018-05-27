module Generate
  module Floor
    def self.place(floor, room, x, y)
      # how many rows to add to the top?
      # how many rows to add to the bottom?
      # how many columns to add to the left?
      # how many columns to add to the right?
      # add all the new rows and columns
      # copy the existing floor into the new floor
      # place the new room
      fw, fh = floor[0..1]
      rw, rh = room[0..1]

      (floor = add_columns_left(floor, -x))       if x < 0
      (floor = add_columns_right(floor, x + rw))  if x + rw > fw
      (floor = add_rows_top(floor, -y))           if y < 0
      (floor = add_rows_bottom(floor, y + rh))    if y + rh > fh
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
