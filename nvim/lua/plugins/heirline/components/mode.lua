local conditions = require 'heirline.conditions'
local icons = require 'config.icons'

local M = {}

M.Mode = {
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  static = {
	    mode_names = {
	      n = 'N',
	      no = 'O',
	      nov = 'O',
	      noV = 'O-L',
	      ['no\22'] = 'O-B',
	      niI = 'N-I',
	      niR = 'N-R',
	      niV = 'N-V',
	      nt = 'N-T',
	      v = 'V',
	      vs = 'V',
	      V = 'V-L',
	      Vs = 'V-L',
	      ['\22'] = 'V-B',
	      ['\22s'] = 'V-B',
	      s = 'S',
	      S = 'S-L',
	      ['\19'] = 'S-B',
	      i = 'I',
	      ic = 'I',
	      ix = 'I',
	      R = 'R',
	      Rc = 'R',
	      Rx = 'R',
	      Rv = 'V-R',
	      Rvc = 'V-R',
	      Rvx = 'V-R',
	      c = 'C',
	      cv = 'EX',
	      r = 'P',
	      rm = 'MORE',
	      ['r?'] = 'CF',
	      ['!'] = 'SH',
	      t = 'T',
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
