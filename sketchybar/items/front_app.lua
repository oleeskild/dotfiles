local colors = require("colors")
local settings = require("settings")

local front_app = sbar.add("item", "front_app", {
  display = "active",
  icon = { drawing = false },
  label = {
      padding_left = 12,
      padding_right = 12,
    font = {
      style = settings.font.style_map["Black"],
      size = 12.0,
    },
    color = colors.color2,
  },
  updates = true,
  background = {
    color = colors.white,
    border_color = colors.color2,
    border_width = 2,
  },
})

front_app:subscribe("front_app_switched", function(env)
  front_app:set({ label = { string = env.INFO } })
end)

front_app:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
