## 2D Level Generator

Randomly generate a room by calling `Room::gen`

* `r` - `int`, rects - the number of overlapping rectangles to generate
* `wr` - `Range`, width range - the range of rectangle widths (min. recommended is 3)
* `hr` - `Range`, height range - the range of ranctangle heights (min.
  recommended is 3)
* `xr` - `Range`, `x` range - the range of x offsets (higher tends to lead to
  more clumps of rectangles)
* `yr` - `Range`, `x` range - the range of x offsets (higher tends to lead to
  more clumps of rectangles)

The ratio of `xr` to `yr` can also suggest a general direction for the
rectangles to travel, similiar to the slope of a line. You'll notice that the
closer this range is to width / height ranges, the more clumped together the
generated rectangles will be.
