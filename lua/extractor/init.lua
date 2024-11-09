local Color = require("extractor.util.color")
local System = require("extractor.util.system")
local Table = require("extractor.util.table")
local Vim = require("extractor.util.vim")

local M = {}

--- Extracts the color groups from the current buffer, and returns them as a table.
--- @param output_path string The path to write the extracted color groups to. Optional.
--- @param background string The expected background value of the colorscheme. An error will be thrown if the background value of the colorscheme does not match this value. Optional.
--- @return table The extracted color groups.
function M.extract(output_path, background)
  M.setup()

  print(
    "Extracting color groups..."
      .. (output_path and " to " .. output_path or "")
      .. (background and " with background " .. background or "")
  )

  local colorscheme_name = Vim.get_colorscheme_name()
  if not colorscheme_name or colorscheme_name == "default" then
    error("Colorscheme failed to configure.")
  end

  local color_group_names = Vim.get_color_group_names_in_buffer()
  print("Color groups in the current buffer: " .. Table.to_json(color_group_names))
  Table.insert_many(color_group_names, "StatusLine", "Cursor", "LineNr", "CursorLine", "CursorLineNr")
  print("Total color groups: " .. Table.to_json(color_group_names))

  local normal_fg_color_value = Vim.get_color_group_value("Normal", "fg#") or "#ffffff"
  local normal_bg_color_value = Vim.get_color_group_value("Normal", "bg#") or "#000000"

  if background == "light" and not Color.is_light(normal_bg_color_value) then
    error("The background of the colorscheme is not light as expected.")
  end

  if background == "dark" and Color.is_light(normal_bg_color_value) then
    error("The background of the colorscheme is not dark as expected.")
  end

  local color_groups = { { name = "Normal", fg = normal_fg_color_value, bg = normal_bg_color_value } }

  for _, color_group_name in ipairs(color_group_names) do
    local fg_color_value = Vim.get_color_group_value(color_group_name, "fg#") or normal_fg_color_value
    local bg_color_value = Vim.get_color_group_value(color_group_name, "bg#") or normal_bg_color_value
    local color_group = { name = color_group_name, fg = fg_color_value, bg = bg_color_value }
    table.insert(color_groups, color_group)
  end

  local json = Table.to_json(color_groups)

  if output_path then
    System.write(output_path, json)
    print("Color groups extracted to " .. output_path)
  end

  print(json)

  M.post_setup()

  return color_groups
end

--- Returns a list of installed custom colorschemes.
--- @param output_path string The path to write the extracted color groups to. Optional.
--- @return table The extracted color groups.
function M.colorschemes(output_path)
  local colorschemes = Vim.get_colorschemes()
  local json = Table.to_json(colorschemes)
  print("Installed colorschemes: " .. json)
  if output_path then
    System.write(output_path, json)
    print("Installed colorschemes extracted to " .. output_path)
  end
  return colorschemes
end

--- Sets up the environment for the extractor.
function M.setup()
  vim.cmd("syntax on")
  vim.o.termguicolors = true

  -- disable treesitter highlighting
  if vim.fn.exists(":TSBufDisable") == 2 then
    vim.cmd("TSBufDisable highlight")
  end
end

-- Post setup actions.
function M.post_setup()
  -- enable treesitter highlighting again
  if vim.fn.exists(":TSBufEnable") == 2 then
    vim.cmd("TSBufEnable highlight")
  end
end

return M
