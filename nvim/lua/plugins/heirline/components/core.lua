local M = {}

M.Spacer = { provider = ' ' }
M.Fill = { provider = '%=' }
M.Ruler = {
  init = function(self)
    self.line = vim.fn.line '.'
    self.column = vim.fn.virtcol '.'
    local total = math.max(vim.fn.line '$', 1)
    self.percent = math.floor(((self.line - 1) / math.max(total - 1, 1)) * 100 + 0.5)
  end,
  {
    provider = '',
    hl = { fg = 'dim', bg = 'bg' },
  },
  {
    provider = function(self)
      return (' %d:%d | %d%%%% '):format(self.line, self.column, self.percent)
    end,
    hl = { fg = 'mode_fg', bg = 'dim', bold = true },
  },
  {
    provider = '',
    hl = { fg = 'dim', bg = 'bg' },
  },
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
