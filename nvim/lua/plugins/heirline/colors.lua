local heirline_utils = require 'heirline.utils'

local M = {}

local function get_hl(name)
  local ok, hl = pcall(heirline_utils.get_highlight, name)
  return ok and hl or {}
end

local function pick(groups, attr, fallback)
  for _, group in ipairs(groups) do
    local value = get_hl(group)[attr]
    if value then
      return value
    end
  end
  return fallback
end

function M.setup()
  local normal_fg = pick({ 'Normal' }, 'fg', '#d0d0d0')
  local normal_bg = pick({ 'Normal' }, 'bg', '#101010')
  local status_fg = pick({ 'StatusLine', 'Normal' }, 'fg', normal_fg)
  local status_bg = pick({ 'StatusLine', 'Normal' }, 'bg', 'NONE')

  return {
    fg = status_fg,
    bg = status_bg,
    mode_fg = pick({ 'StatusLine', 'Normal' }, 'bg', normal_bg),
    dim = pick({ 'Comment', 'NonText' }, 'fg', status_fg),
    red = pick({ 'DiagnosticError', 'ErrorMsg' }, 'fg', status_fg),
    yellow = pick({ 'DiagnosticWarn', 'WarningMsg' }, 'fg', status_fg),
    green = pick({ 'String', 'DiagnosticOk' }, 'fg', status_fg),
    blue = pick({ 'Function', 'Directory' }, 'fg', status_fg),
    magenta = pick({ 'Statement', 'PreProc' }, 'fg', status_fg),
    cyan = pick({ 'Special', 'Identifier' }, 'fg', status_fg),
    orange = pick({ 'Constant', 'Number' }, 'fg', status_fg),
    diag_error = pick({ 'DiagnosticError' }, 'fg', status_fg),
    diag_warn = pick({ 'DiagnosticWarn' }, 'fg', status_fg),
    diag_info = pick({ 'DiagnosticInfo' }, 'fg', status_fg),
    diag_hint = pick({ 'DiagnosticHint' }, 'fg', status_fg),
    git_add = pick({ 'GitSignsAdd', 'diffAdded' }, 'fg', status_fg),
    git_change = pick({ 'GitSignsChange', 'diffChanged' }, 'fg', status_fg),
    git_delete = pick({ 'GitSignsDelete', 'diffDeleted' }, 'fg', status_fg),
    file = pick({ 'Identifier', 'Normal' }, 'fg', status_fg),
    type = pick({ 'Type', 'Normal' }, 'fg', status_fg),
  }
end

return M
