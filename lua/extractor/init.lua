local Color = require("extractor.util.color")
local System = require("extractor.util.system")
local Table = require("extractor.util.table")
local Vim = require("extractor.util.vim")

local M = {}

--- Extracts the color groups from the current buffer, and returns them as a table.
--- @param output_path string The path to write the extracted color groups to. Optional.
--- @param background string The expected background value of the colorscheme. An error will be thrown if the background value of the colorscheme does not match this value. Optional.
--- @return table The extracted color groups.
function M.run(output_path, background)
  local color_group_names = Vim.get_color_group_names_in_buffer()
  Table.insert_many(color_group_names, "StatusLine", "Cursor", "LineNr", "CursorLine", "CursorLineNr")

  local normal_fg_color_value = Vim.get_color_group_value("Normal", "fg#") or "#ffffff"
  local normal_bg_color_value = Vim.get_color_group_value("Normal", "bg#") or "#000000"

  if background == "light" and not Color.is_light(normal_bg_color_value) then
    error("The background of the colorscheme is not light.")
  end

  if background == "dark" and Color.is_light(normal_bg_color_value) then
    error("The background of the colorscheme is not dark.")
  end

  local color_groups = { { name = "Normal", fg = normal_fg_color_value, bg = normal_bg_color_value } }

  for _, color_group_name in ipairs(color_group_names) do
    local fg_color_value = Vim.get_color_group_value(color_group_name, "fg#") or normal_fg_color_value
    local bg_color_value = Vim.get_color_group_value(color_group_name, "bg#") or normal_bg_color_value
    local color_group = { name = color_group_name, fg = fg_color_value, bg = bg_color_value }
    table.insert(color_groups, color_group)
  end

  if output_path then
    local json = Table.to_json(color_groups)
    System.write(output_path, json)
  end

  return color_groups
end

return M
