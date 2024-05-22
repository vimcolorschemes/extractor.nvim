local Color = require("extractor.util.color")

local M = {}

function M.init()
  print("Color test")
  print(Color.is_hex_color_light("#ffffff"))
  print(Color.is_hex_color_light("#000000"))
end

return M
