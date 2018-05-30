module Merger
  # Replaces the contents of a with b.
  def self.overwrite(a, b)
    b
  end

  # Merges r2 on top of r1, using merge_winner to determine which tile between
  # the two should be the applied.
  def self.merge(r1, r2)
    r1.map.with_index{|c, i| merge_winner(c, r2[i]) }
  end

  # Simple business rule that says that open space should win, and if no open
  # space is involved, then the highest number (i.e. walls, in this case) should
  # prevail.
  def self.merge_winner(a, b)
    return 0 if a == 0 || b == 0
    [a, b].max
  end
end
