module Generate
  module Room
    def self.gen(w, h)
      r = [w, h]
      r << [1] * w
      (h - 2).times{ r << [1, [0] * (w - 2), 1] }
      r << [1] * w
      r.flatten
    end
  end
end
