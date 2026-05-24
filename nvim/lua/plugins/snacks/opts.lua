return {
  bigfile = { enabled = true },
  dashboard = require 'plugins.snacks.dashboard',
  explorer = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = {
    enabled = true,
    timeout = 3000,
  },
  picker = { enabled = true, ui_select = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = {
    enabled = true,
    folds = {
      open = false,
      git_hl = false,
    },
  },
  words = { enabled = true },
  styles = {
    notification = {
      -- wo = { wrap = true }
    },
  },
  image = { enabled = true },
}
