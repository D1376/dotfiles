local icons = require 'config.icons'

local function key(icon, key, desc, action, extra)
  return vim.tbl_extend('force', {
    icon = icon.icon,
    icon_hl = icon.hl,
    key = key,
    desc = desc,
    action = action,
  }, extra or {})
end

return {
  enabled = true,
  formats = {
    icon = function(item)
      return { item.icon, width = 2, hl = item.icon_hl or 'icon' }
    end,
  },
  preset = {
    keys = {
      key(icons.dashboard.FindFile, 'f', 'Find File', ":lua Snacks.dashboard.pick('files')"),
      key(icons.dashboard.NewFile, 'n', 'New File', ':ene | startinsert'),
      key(icons.dashboard.FindText, 'g', 'Find Text', ":lua Snacks.dashboard.pick('live_grep')"),
      key(icons.dashboard.RecentFiles, 'r', 'Recent Files', ":lua Snacks.dashboard.pick('oldfiles')"),
      key(icons.dashboard.Config, 'c', 'Config', ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})"),
      key(icons.dashboard.RestoreSession, 's', 'Restore Session', nil, { section = 'session' }),
      key(icons.dashboard.Mason, 'm', 'Mason', ':Mason', { enabled = package.loaded.lazy ~= nil }),
      key(icons.dashboard.Lazy, 'l', 'Lazy', ':Lazy', { enabled = package.loaded.lazy ~= nil }),
      key(icons.dashboard.Quit, 'q', 'Quit', ':qa'),
    },
  },
}
