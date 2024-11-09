local M = {}

--- Writes to a files.
--- @param path string The path to write to.
--- @param content string The content to write.
function M.write(path, content)
  local file = io.open(path, "w")
  if not file then
    error("Could not open file: " .. path)
  end
  file:write(content)
  file:close()
end

return M
