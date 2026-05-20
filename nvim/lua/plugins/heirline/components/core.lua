local icons = require 'config.icons'

local M = {}

M.Spacer = { provider = ' ' }
M.Fill = { provider = '%=' }
M.Ruler = {
  provider = function()
    local line = vim.fn.line '.'
    local column = vim.fn.virtcol '.'
    local total = math.max(vim.fn.line '$', 1)
    local percent = math.floor(((line - 1) / math.max(total - 1, 1)) * 100 + 0.5)

    return (' %s %d %s %d %s %d%%'):format(icons.status.Line, line, icons.status.Column, column, icons.status.Position, percent)
  end,
  hl = { fg = 'dim' },
}

function M.RightPadding(child, num_space)
  if not child then
    return {}
  end

  local result = {}
  if child.condition ~= nil then
    result.condition = child.condition
  end

  table.insert(result, child)
  if num_space ~= nil then
    for _ = 1, num_space do
      table.insert(result, M.Spacer)
    end
  end
  return result
end

return M
