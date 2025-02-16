local Table = require("extractor.util.table")
local Color = require("extractor.util.color")

local M = {}

--- Return all the possible cursor positions in line and column for the current buffer.
--- @return table cursor_positions The list of cursor positions in the buffer.
function M.get_cursor_positions()
  local cursor_positions = {}
  for line_number, line in ipairs(M.get_lines()) do
    for _, col in ipairs(M.get_columns(line)) do
      table.insert(cursor_positions, { col = col, line = line_number })
    end
  end
  return cursor_positions
end

--- Return all the lines in the current buffer.
--- @return table lines The list of lines in the buffer.
function M.get_lines()
  local lines = {}
  for line_number = 1, vim.api.nvim_buf_line_count(0) do
    local line = vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]
    table.insert(lines, line)
  end
  return lines
end

--- Return all the columns in the current buffer at a given line.
--- @param line string The line to get the columns from.
--- @return table columns The list of columns in the line.
function M.get_columns(line)
  local columns = {}
  for col = 1, #line do
    table.insert(columns, col)
  end
  return columns
end

--- Return all unique color groups of the text in the current buffer, as well
--- as some default ones.
--- @return table color_group_names The list of color groups.
function M.get_color_group_names()
  local color_group_names = M.get_color_group_names_in_buffer()
  table.insert(color_group_names, "Normal")
  table.insert(color_group_names, "StatusLine")
  table.insert(color_group_names, "Cursor")
  table.insert(color_group_names, "LineNr")
  table.insert(color_group_names, "CursorLine")
  table.insert(color_group_names, "CursorLineNr")
  return color_group_names
end

--- Return all unique color groups of the text in the current buffer.
--- @return table color_group_names The list of color groups in the buffer.
function M.get_color_group_names_in_buffer()
  local cursor_positions = M.get_cursor_positions()

  local color_group_names = {}
  for _, cursor_position in ipairs(cursor_positions) do
    local color_group_name = M.get_color_group_name_at(cursor_position.col, cursor_position.line)
    Table.insert_if_not_exists(color_group_names, color_group_name)
  end

  return color_group_names
end

--- Return the color group of the text at the given line and column.
--- @param col number The column number
--- @param line number The line number
--- @return nil|string color_group_name The group name of the color at the given line and column.
function M.get_color_group_name_at(col, line)
  local synID = vim.fn.synID(line, col, 1)
  if synID == 0 then
    return nil
  end

  local color_group_name = vim.fn.synIDattr(synID, "name")
  if color_group_name == "" then
    return nil
  end

  return color_group_name
end

--- Return a list of installed colorschemes, excluding the default colorscheme.
--- @return table colorschemes The list of installed colorschemes.
function M.get_colorschemes()
  local colorschemes = {}

  local completions = vim.fn.getcompletion("", "color")
  for _, colorscheme in ipairs(completions) do
    if colorscheme ~= "default" then
      table.insert(colorschemes, colorscheme)
    end
  end

  return colorschemes
end

--- Returns the color group data including the fg and bg colors.
--- @param group string The group name.
--- @param mode "cterm"|"gui" The mode to get the colors in.
--- @return table|nil The highlight colors.
function M.get_highlight(group, mode)
  local highlight = vim.api.nvim_get_hl(0, { name = group, link = false })
  if highlight == nil then
    return nil
  end

  local is_cterm_defined = highlight.ctermfg ~= nil or highlight.ctermbg ~= nil
  if mode == "cterm" and is_cterm_defined then
    return {
      fg = highlight.ctermfg ~= nil and Color.term_to_hex(highlight.ctermfg) or nil,
      bg = highlight.ctermbg ~= nil and Color.term_to_hex(highlight.ctermbg) or nil,
    }
  end

  if mode == "cterm" then
    return nil
  end

  local is_gui_defined = highlight.fg ~= nil or highlight.bg ~= nil
  if is_gui_defined then
    return {
      fg = highlight.fg ~= nil and Color.decimal_rgb_to_hex(highlight.fg) or nil,
      bg = highlight.bg ~= nil and Color.decimal_rgb_to_hex(highlight.bg) or nil,
    }
  end

  return nil
end

function M.is_colorscheme_cterm() end

return M
