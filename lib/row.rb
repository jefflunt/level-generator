module Row
  ##
  # To get the (approximate) middle index of the longest wall, try:
  #
  #   Row.midpoint(Row.longest_wall(r))
  def self.midpoint(range)
    m = range.min + (range.size / 2)
  end

  def self.longest_wall(r)
    walls(r).max{|a, b| a.size <=> b.size }
  end

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
