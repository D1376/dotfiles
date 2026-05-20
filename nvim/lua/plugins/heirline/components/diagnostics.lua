local conditions = require 'heirline.conditions'
local helpers = require 'plugins.heirline.components.helpers'
local icons = require 'plugins.heirline.icons'

local M = {}

M.Diagnostics = {
  condition = conditions.has_diagnostics,
  static = {
    error_icon = icons.diagnostics.Error .. ' ',
    warn_icon = icons.diagnostics.Warn .. ' ',
    info_icon = icons.diagnostics.Info .. ' ',
    hint_icon = icons.diagnostics.Hint .. ' ',
  },
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  end,
  update = { 'DiagnosticChanged', 'BufEnter' },
  {
    provider = function(self)
      return self.errors > 0 and (self.error_icon .. self.errors .. ' ')
    end,
    hl = { fg = 'diag_error' },
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings .. ' ')
    end,
    hl = { fg = 'diag_warn' },
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. self.info .. ' ')
    end,
    hl = { fg = 'diag_info' },
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints .. ' ')
    end,
    hl = { fg = 'diag_hint' },
  },
  on_click = {
    name = 'heirline_diagnostics',
    callback = helpers.snacks_call(function(snacks)
      if snacks.picker and snacks.picker.diagnostics_buffer then
        snacks.picker.diagnostics_buffer()
      end
    end),
  },
}

return M
