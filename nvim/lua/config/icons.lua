local M = {}

M.diagnostics = {
  Error = '󰅚',
  Warn = '󰀪',
  Info = '󰋽',
  Hint = '󰌶',
}

M.git = {
  Branch = '',
  Dirty = '*',
  Added = '',
  Removed = '',
  Changed = '',
}

M.status = {
  DefaultFile = '󰈙',
  Terminal = '',
  Modified = '[+]',
  Readonly = '',
  Lsp = '',
  Search = '',
  Macro = '',
  Mode = '',
  Spinner = '',
  Line = '',
  Column = '',
  Position = '󰍒',
}

M.dashboard = {
  FindFile = { icon = '󰈞 ', hl = 'icon' },
  NewFile = { icon = '󰈔 ', hl = 'icon' },
  FindText = { icon = '󰱼 ', hl = 'icon' },
  RecentFiles = { icon = '󰋚 ', hl = 'icon' },
  Config = { icon = '󰒓 ', hl = 'icon' },
  RestoreSession = { icon = '󰦛 ', hl = 'icon' },
  Mason = { icon = '󰏗 ', hl = 'icon' },
  Lazy = { icon = '󰒲 ', hl = 'icon' },
  Quit = { icon = '󰗼 ', hl = 'icon' },
}

M.which_key = {
  buffer = { icon = ' ', color = 'blue' },
  code = { icon = ' ', color = 'azure' },
  debug = { icon = ' ', color = 'red' },
  git = { icon = ' ', color = 'orange' },
  file = { icon = '󰈞 ', color = 'blue' },
  hunk = { icon = '󰊢 ', color = 'orange' },
  lsp = { icon = ' ', color = 'green' },
  search = { icon = ' ', color = 'cyan' },
  toggle = { icon = ' ', color = 'yellow' },
  ui = { icon = '󰙵 ', color = 'cyan' },
  ['goto'] = { icon = '󰿅 ', color = 'purple' },
  fold = { icon = ' ', color = 'purple' },
}

M.which_key_items = {
  smart_files = { icon = '󰈞 ', color = 'blue' },
  buffers = { icon = ' ', color = 'blue' },
  grep = { icon = ' ', color = 'cyan' },
  command_history = { icon = ' ', color = 'yellow' },
  breakpoint = { icon = ' ', color = 'red' },
  diagnostics = { icon = ' ', color = 'yellow' },
  explorer = { icon = ' ', color = 'blue' },
  notifications = { icon = ' ', color = 'purple' },
  news = { icon = ' ', color = 'cyan' },
  scratch = { icon = ' ', color = 'green' },
  scratch_select = { icon = '󰒮 ', color = 'green' },
  zen = { icon = '󱅻 ', color = 'purple' },
  zoom = { icon = ' ', color = 'cyan' },
}

M.dap = {
  ui = {
    expanded = '',
    collapsed = '',
    current_frame = '',
  },
  controls = {
    pause = '',
    play = '',
    step_into = '',
    step_over = '',
    step_out = '',
    step_back = '',
    run_last = '',
    terminate = '',
    disconnect = '',
  },
  breakpoints = {
    Breakpoint = '',
    BreakpointCondition = '',
    BreakpointRejected = '',
    LogPoint = '',
    Stopped = '',
  },
}

return M
