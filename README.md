## 2D Level Generator

Randomly generate a room by calling `Room::gen`

* `r` - `int`, rects - the number of overlapping rectangles to generate
* `wr` - `Range`, width range - the range of rectangle widths (min. recommended is 3)
* `hr` - `Range`, height range - the range of ranctangle heights (min.
  recommended is 3)
* `xr` - `Range`, `x` range - the range of x offsets
* `yr` - `Range`, `x` range - the range of x offsets

The ratio of `xr` to `yr` can also suggest a general direction (or lack of
direction) for the rectangles to travel, sort of like the slope of a line.

* The closer the `xr` / `yr` ranges are to the `wr` / `hr` ranges respectively,
  the more clumpy the room will be.
* Very low `xr` / `yr` ranges (i.e. try setting them to a fixed `1..1`) will
  result in the rectangles being generated along a very clear line.
* Finally, if the `xr` / `yr` ranges' top end extend quite a bit beyond the `wr`
  / `hr` ranges, you'll notice that more chaotic rooms result, often with rooms
  within rooms that don't touch one another.
