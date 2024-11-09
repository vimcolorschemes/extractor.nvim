local M = {}

--- Insert multiple elements into a table.
--- @param t table The table to insert the elements into.
--- @param ... any The elements to insert into the table.
function M.insert_many(t, ...)
  for _, v in ipairs({ ... }) do
    table.insert(t, v)
  end
end

--- Insert an element into a table if it does not already exist.
--- @param t table The table to insert the element into.
--- @param v any The element to insert into the table.
function M.insert_if_not_exists(t, v)
  if not M.contains(t, v) then
    table.insert(t, v)
  end
end

--- Convert a table to a JSON string.
--- @param t table The table to convert to a JSON string.
--- @return string The encoded JSON string.
function M.to_json(t)
  return vim.fn.json_encode(t)
end

--- Checks if an item exists in a table.
--- @param t table The table to check.
--- @param item any The item to check for.
--- @return boolean Whether the item exists in the table.
function M.contains(t, item)
  return vim.tbl_contains(t, item)
end

return M
