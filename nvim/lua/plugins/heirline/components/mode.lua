local conditions = require 'heirline.conditions'
local icons = require 'config.icons'

local M = {}

M.Mode = {
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  static = {
    mode_names = {
      n = 'NORMAL',
      no = 'OPERATOR',
      nov = 'OPERATOR',
      noV = 'OPERATOR LINE',
      ['no\22'] = 'OPERATOR BLOCK',
      niI = 'NORMAL INSERT',
      niR = 'NORMAL REPLACE',
      niV = 'NORMAL VIRTUAL',
      nt = 'NORMAL TERMINAL',
      v = 'VISUAL',
      vs = 'VISUAL',
      V = 'VISUAL LINE',
      Vs = 'VISUAL LINE',
      ['\22'] = 'VISUAL BLOCK',
      ['\22s'] = 'VISUAL BLOCK',
      s = 'SELECT',
      S = 'SELECT LINE',
      ['\19'] = 'SELECT BLOCK',
      i = 'INSERT',
      ic = 'INSERT',
      ix = 'INSERT',
      R = 'REPLACE',
      Rc = 'REPLACE',
      Rx = 'REPLACE',
      Rv = 'VIRTUAL REPLACE',
      Rvc = 'VIRTUAL REPLACE',
      Rvx = 'VIRTUAL REPLACE',
      c = 'COMMAND',
      cv = 'EX',
      r = 'PROMPT',
      rm = 'MORE',
      ['r?'] = 'CONFIRM',
      ['!'] = 'SHELL',
      t = 'TERMINAL',
    },
    mode_colors = {
      n = 'blue',
      i = 'green',
      v = 'magenta',
      V = 'magenta',
      ['\22'] = 'magenta',
      c = 'red',
      s = 'magenta',
      S = 'magenta',
      ['\19'] = 'magenta',
      R = 'orange',
      r = 'orange',
      ['!'] = 'red',
      t = 'blue',
    },
  },
  {
    provider = '',
    hl = function(self)
      local mode = self.mode:sub(1, 1)
      return { fg = self.mode_colors[mode] or 'dim', bg = 'bg' }
    end,
  },
  {
    provider = function(self)
      local label = self.mode_names[self.mode] or self.mode:sub(1, 1):upper()
      return (' %s %s '):format(icons.status.Mode, label)
    end,
    hl = function(self)
      local mode = self.mode:sub(1, 1)
      return { fg = 'mode_fg', bg = self.mode_colors[mode] or 'dim', bold = true }
    end,
  },
  {
    provider = '',
    hl = function(self)
      local mode = self.mode:sub(1, 1)
      return { fg = self.mode_colors[mode] or 'dim', bg = 'bg' }
    end,
  },
  update = {
    'ModeChanged',
    pattern = '*:*',
    callback = vim.schedule_wrap(function()
      pcall(vim.cmd, 'redrawstatus')
    end),
  },
}

M.MacroRecording = {
  condition = conditions.is_active,
  init = function(self)
    self.reg_recording = vim.fn.reg_recording()
  end,
  {
    condition = function(self)
      return self.reg_recording ~= ''
    end,
    {
      provider = icons.status.Macro .. ' ',
      hl = { fg = 'orange' },
    },
    {
      provider = function(self)
        return self.reg_recording
      end,
      hl = { fg = 'orange', bold = true },
    },
  },
  update = { 'RecordingEnter', 'RecordingLeave' },
}

return M
