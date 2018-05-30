module Row
  # Takes a Range, and returns the (approximate) midpoint, rounding down.
  #
  # Combine this with the longest_wall method to get the midpoint index of the
  # longest wall:
  #
  #   Row.midpoint(Row.longest_wall(r))
  def self.midpoint(range)
    m = range.min + (range.size / 2)
  end

  # Takes a list of ranges where walls appear, and returns the range that is the
  # largest.
  def self.longest_wall(r)
    walls(r).max{|a, b| a.size <=> b.size }
  end

  # Takes a row and returns an array of ranges of indexes where walls exist.
  #  > row = [0, 1, 1, 0, 0, 1, 0, 1, 1, 1]
  # => [1..2, 5..5, 7..9]
  def self.walls(r)
    ws = []

    wall = nil
    r.each_with_index do |c, i|
      if wall.nil? && c == 1
        wall = i
      elsif wall && c != 1
        ws = [ws, wall..(i - 1)].flatten
        wall = nil
      end
    end

    ws = [ws, wall..(r.length - 1)].flatten if wall
    ws
  end
end
