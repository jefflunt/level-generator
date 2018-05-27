module Merger
  def self.overwrite(a, b)
    b
  end

  def self.merge(r1, r2)
    r1.map.with_index{|c, i| merge_winner(c, r2[i]) }
  end

  def self.merge_winner(a, b)
    return 0 if a == 0 || b == 0
    [a, b].max
  end
end
