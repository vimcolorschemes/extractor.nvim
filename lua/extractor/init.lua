local Vim = require("extractor.util.vim")
local Table = require("extractor.util.table")

local M = {}

function M.run()
  local color_group_names = Vim.get_color_group_names_in_buffer()
  Table.insert_many(color_group_names, "StatusLine", "Cursor", "LineNr", "CursorLine", "CursorLineNr")

  local normal_fg_color_value = Vim.get_color_group_value("Normal", "fg#") or "#ffffff"
  local normal_bg_color_value = Vim.get_color_group_value("Normal", "bg#") or "#000000"

  local color_groups = { { name = "Normal", fg = normal_fg_color_value, bg = normal_bg_color_value } }
  for _, color_group_name in ipairs(color_group_names) do
    local fg_color_value = Vim.get_color_group_value(color_group_name, "fg#") or normal_fg_color_value
    local bg_color_value = Vim.get_color_group_value(color_group_name, "bg#") or normal_bg_color_value
    local color_group = { name = color_group_name, fg = fg_color_value, bg = bg_color_value }
    table.insert(color_groups, color_group)
  end
  return color_groups
end

return M
