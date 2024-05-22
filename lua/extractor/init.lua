local Color = require("lua.extractor.util.color")

local M = {}

function M.hello_world()
  print(Color.is_hex_color_light("#ffffff"))
  print(Color.is_hex_color_light("#000000"))
end

return M
