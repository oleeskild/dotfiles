local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  topmost = "window",
  height = 35,
  color = colors.transparent,
  padding_right = 2,
  padding_left = 2,
  margin = 5,
  corner_radius = 10,
  y_offset = 3,
})
