local icons = require 'config.icons'

local M = {}

M.ShowCmd = {
  condition = function()
    return vim.o.cmdheight == 0
  end,
  provider = ' %3.5(%S%) ',
  hl = { fg = 'dim' },
}

M.SearchOccurrence = {
  condition = function()
    return vim.v.hlsearch == 1
  end,
  update = { 'CursorMoved', 'CmdlineLeave' },
  provider = function()
    local sinfo = vim.fn.searchcount { maxcount = 0 }
    if sinfo.incomplete > 0 then
      return icons.status.Search .. ' [?/?]'
    end
    return sinfo.total > 0 and (icons.status.Search .. ' [%s/%s]'):format(sinfo.current, sinfo.total) or ''
  end,
  hl = { fg = 'cyan' },
}

M.SimpleIndicator = {
  condition = function()
    return vim.g.simple_indicator_on
  end,
  provider = icons.status.Spinner .. ' ',
  hl = { fg = 'cyan' },
}

return M
