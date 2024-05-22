local M = {}

--- Return true if the color is considered to be light, false otherwise. Based on the brightness of the RGB color values.
--- @param color string
--- @return boolean
function M.is_hex_color_light(color)
  local raw_color = string.gsub(color, "#", "")
  local red = tonumber(string.sub(raw_color, 1, 2), 16)
  local green = tonumber(string.sub(raw_color, 3, 4), 16)
  local blue = tonumber(string.sub(raw_color, 5, 6), 16)

  local brightness = ((red * 299) + (green * 587) + (blue * 114)) / 1000

  return brightness > 155
end

return M
