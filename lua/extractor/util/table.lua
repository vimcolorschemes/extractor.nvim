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
  if not vim.tbl_contains(t, v) then
    table.insert(t, v)
  end
end

function M.to_json(t)
  return vim.fn.json_encode(t)
end

return M
