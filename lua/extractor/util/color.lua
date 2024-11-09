local M = {}

--- Checks wheter a color is considered to be light or dark.
--- @param color string The color to check.
--- @return boolean True if the color is light, false if the color is dark.
function M.is_light(color)
  local r, g, b = M.hex_to_rgb(color)
  if not r or not g or not b then
    return false
  end

  local brightness = (r * 299 + g * 587 + b * 114) / 1000
  return brightness > 155
end

--- Converts a hex color to an RGB color.
--- @param hex string The hex color to convert.
--- @return number?, number?, number? The RGB color.
function M.hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

return M
