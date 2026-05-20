local conditions = require 'heirline.conditions'
local helpers = require 'plugins.heirline.components.helpers'
local icons = require 'config.icons'

local M = {}

M.LSPActive = {
  condition = conditions.lsp_attached,
  update = { 'LspAttach', 'LspDetach', 'BufEnter' },
  provider = function()
    local names = {}
    for _, server in pairs(vim.lsp.get_clients { bufnr = 0 }) do
      names[#names + 1] = server.name
    end
    table.sort(names)
    return icons.status.Lsp .. ' ' .. table.concat(names, ' ') .. ' '
  end,
  hl = { fg = 'green', bold = true },
  on_click = {
    name = 'heirline_lsp_symbols',
    callback = helpers.snacks_call(function(snacks)
      if snacks.picker and snacks.picker.lsp_symbols then
        snacks.picker.lsp_symbols()
      end
    end),
  },
}

M.Formatters = {
  condition = function()
    return #helpers.formatter_labels() > 0
  end,
  update = { 'BufEnter', 'FileType', 'LspAttach', 'LspDetach' },
  provider = function()
    local labels = helpers.formatter_labels()
    return #labels > 0 and ('󰉢 ' .. table.concat(labels, ',')) or ''
  end,
  hl = { fg = 'dim' },
  on_click = {
    name = 'heirline_formatters',
    callback = function()
      pcall(vim.cmd, 'ConformInfo')
    end,
  },
}

return M
