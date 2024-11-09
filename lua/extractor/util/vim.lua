local Table = require("extractor.util.table")

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

--- Return the value of the color group.
--- @param color_group_name string The name of the color group.
--- @param attribute string The attribute of the color group. Can be "fg#" or "bg#".
--- @return string|nil color_group_value The value of the color group.
function M.get_color_group_value(color_group_name, attribute)
  local synID = vim.fn.hlID(color_group_name)
  if synID == 0 then
    return nil
  end

  local color_group_value = vim.fn.synIDattr(synID, attribute)
  if color_group_value == "" then
    return nil
  end

  return color_group_value
end

--- Return the name of the current colorscheme.
--- @return string colorscheme_name The name of the current colorscheme.
function M.get_colorscheme_name()
  return vim.g.colors_name
end

local DEFAULT_COLORSCHEMES = {
  "blue",
  "darkblue",
  "default",
  "delek",
  "desert",
  "elflord",
  "evening",
  "habamax",
  "industry",
  "koehler",
  "lunaperche",
  "morning",
  "murphy",
  "pablo",
  "peachpuff",
  "quiet",
  "retrobox",
  "ron",
  "shine",
  "slate",
  "sorbet",
  "torte",
  "vim",
  "wildcharm",
  "zaibatsu",
  "zellner",
  "wildcharm",
}

--- Return a list of installed colorschemes, excluding the default list.
--- @return table colorschemes The list of installed colorschemes.
function M.get_colorschemes()
  local colorschemes = {}

  local completions = vim.fn.getcompletion("", "color")
  for _, colorscheme in ipairs(completions) do
    if not Table.contains(DEFAULT_COLORSCHEMES, colorscheme) then
      table.insert(colorschemes, colorscheme)
    end
  end

  return colorschemes
end

return M
