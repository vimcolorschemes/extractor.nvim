local Color = require("extractor.util.color")
local System = require("extractor.util.system")
local Table = require("extractor.util.table")
local Vim = require("extractor.util.vim")

local M = {}

local function is_colorschemes_valid(colorschemes)
  return type(colorschemes) == "table" and #colorschemes > 0
end

local function is_output_path_valid(output_path)
  return type(output_path) == "string" and #output_path > 0
end

local function set_colorscheme(colorscheme)
  pcall(function()
    vim.cmd("silent! colorscheme " .. colorscheme)
    vim.fn.execute("syntax on")
  end)
end

local function set_background(background)
  pcall(function()
    vim.cmd("set background=" .. background)
  end)
end

--- Checks if the current colorscheme is using cterm colors. This is determined
--- by checking if the normal highlight share the same gui colors as the
--- default colorscheme.
--- @param excluded_highlight table The highlight to exclude.
--- @return boolean
local function is_colorscheme_cterm(excluded_highlight)
  local normal_highlight = vim.api.nvim_get_hl(0, { name = "Normal", link = false })

  if normal_highlight.fg ~= excluded_highlight.fg or normal_highlight.bg ~= excluded_highlight.bg then
    return false
  end

  return normal_highlight.ctermfg ~= nil or normal_highlight.ctermbg ~= nil
end

--- Checks if the current colorscheme is excluded. This is determined by checking
--- if the normal highlight share the same colors as the default colorscheme.
--- @param excluded_highlight table The highlight to exclude.
--- @return boolean
local function is_colorscheme_excluded(excluded_highlight)
  local normal_highlight = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  return normal_highlight.fg == excluded_highlight.fg and normal_highlight.bg == excluded_highlight.bg
end

--- For each installed colorscheme, try both light and dark backgrounds, then
--- extracts the color groups and writes them to a file.
--- @param output_path string The path to write the extracted color groups to. Optional.
function M.extract(output_path)
  local colorschemes = Vim.get_colorschemes()
  if not is_colorschemes_valid(colorschemes) then
    print("No colorschemes found.")
    return
  end
  if #colorschemes > 100 then
    print("More than 100 colorschemes found. Not supported.")
    return
  end

  set_colorscheme("default")
  set_background("dark")

  local default_dark_normal_highlight = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  if default_dark_normal_highlight == nil then
    print("Failed to get default normal highlight.")
    return
  end

  set_colorscheme("default")
  set_background("light")

  local default_light_normal_highlight = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  if default_light_normal_highlight == nil then
    print("Failed to get default normal highlight.")
    return
  end

  local color_group_names = Vim.get_color_group_names()

  local data = {}

  for _, colorscheme in ipairs(colorschemes) do
    for _, background in ipairs({ "dark", "light" }) do
      set_background(background)
      set_colorscheme(colorscheme)
      -- Set twice to ensure no leftover settings from previous backgrounds.
      set_background(background)
      if vim.g.colors_name ~= colorscheme then
        print("Failed to set colorscheme: " .. colorscheme)
        goto next_background
      end
      if vim.o.background ~= background then
        print("Failed to set background: " .. background)
        goto next_background
      end

      local excluded_highlight = background == "dark" and default_dark_normal_highlight
        or default_light_normal_highlight
      local mode = is_colorscheme_cterm(excluded_highlight) and "cterm" or "gui"

      if mode == "gui" and is_colorscheme_excluded(excluded_highlight) then
        print("Colorscheme is equal to default")
        goto next_background
      end

      local normal_highlight = Vim.get_highlight("Normal", mode)
      if normal_highlight == nil or normal_highlight.fg == nil or normal_highlight.bg == nil then
        print("Failed to get normal highlight.")
        goto next_background
      end

      local current_background = Color.is_light(normal_highlight.bg) and "light" or "dark"
      if current_background ~= background then
        print("Background color does not match: " .. current_background .. " vs " .. background)
        goto next_background
      end

      data[colorscheme] = data[colorscheme] or {}
      data[colorscheme][background] = data[colorscheme][background] or {}

      for _, color_group_name in ipairs(color_group_names) do
        local highlight = Vim.get_highlight(color_group_name, mode)
        if highlight and highlight.fg then
          table.insert(data[colorscheme][background], { name = color_group_name .. "Fg", hexCode = highlight.fg })
        end
        if highlight and highlight.bg then
          table.insert(data[colorscheme][background], { name = color_group_name .. "Bg", hexCode = highlight.bg })
        end
      end

      ::next_background::
    end
  end

  if #data == 0 then
    print("No colors extracted.")
    return
  end

  local json = Table.to_json(data)

  if is_output_path_valid(output_path) then
    System.write(output_path, json)
  end
end

--- Returns a list of installed colorschemes.
--- @param output_path string The path to write the extracted color groups to. Optional.
--- @return table The colorschemes.
function M.colorschemes(output_path)
  local colorschemes = Vim.get_colorschemes()
  local json = Table.to_json(colorschemes)
  if is_output_path_valid(output_path) then
    System.write(output_path, json)
  end
  return colorschemes
end

return M
