local helpers = require 'plugins.heirline.components.helpers'
local icons = require 'config.icons'

local M = {}

M.FileType = {
  provider = function()
    return vim.bo.filetype
  end,
  hl = { fg = 'type', bold = true },
}

M.FileIcon = {
  condition = function(self)
    return self.filename ~= ''
  end,
  init = function(self)
    self.icon, self.icon_color = helpers.get_mini_icon(self.filename, helpers.buf_option(self.bufnr, 'buftype'))
  end,
  provider = function(self)
    return self.icon and (self.icon .. ' ')
  end,
  hl = function(self)
    return { fg = self.icon_color or 'file' }
  end,
}

M.FileName = {
  init = function(self)
    self.is_modified = helpers.buf_option(self.bufnr, 'modified')
  end,
  provider = function(self)
    if self.filename ~= '' then
      return vim.fn.fnamemodify(self.filename, ':t')
    end

    local filetype = helpers.buf_option(self.bufnr, 'filetype')
    if filetype ~= '' then
      return filetype
    end

    local buftype = helpers.buf_option(self.bufnr, 'buftype')
    return buftype ~= '' and buftype or '[No Name]'
  end,
  hl = function(self)
    return { fg = 'fg', bold = self.is_modified }
  end,
}

M.FileFlags = {
  {
    condition = function(self)
      return self.filename ~= '' and helpers.buf_option(self.bufnr, 'modified')
    end,
    provider = ' ' .. icons.status.Modified,
    hl = function(self)
      return { fg = self.icon_color or 'orange', bold = true }
    end,
  },
  {
    condition = function(self)
      return helpers.buf_option(self.bufnr, 'buftype') ~= 'terminal'
        and (not helpers.buf_option(self.bufnr, 'modifiable') or helpers.buf_option(self.bufnr, 'readonly'))
    end,
    provider = ' ' .. icons.status.Readonly,
    hl = { fg = 'dim' },
  },
}

M.FileNameBlock = {
  init = function(self)
    self.bufnr = self.bufnr or 0
    self.filename = vim.api.nvim_buf_get_name(self.bufnr)
  end,
  M.FileIcon,
  M.FileName,
  M.FileFlags,
  on_click = {
    name = 'heirline_buffers',
    callback = helpers.snacks_call(function(snacks)
      if snacks.picker and snacks.picker.buffers then
        snacks.picker.buffers()
      end
    end),
  },
}

return M
