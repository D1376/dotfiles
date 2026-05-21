local conditions = require 'heirline.conditions'
local helpers = require 'plugins.heirline.components.helpers'
local icons = require 'config.icons'

local M = {}

M.Git = {
  condition = function()
    local status = vim.b.gitsigns_status_dict
    return conditions.is_git_repo() and status and status.head and status.head ~= ''
  end,
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict or {}
    self.has_changes = (self.status_dict.added or 0) ~= 0 or (self.status_dict.removed or 0) ~= 0 or (self.status_dict.changed or 0) ~= 0
  end,
  hl = { fg = 'git_branch' },
  {
    provider = function(self)
      return icons.git.Branch .. ' ' .. self.status_dict.head .. (self.has_changes and icons.git.Dirty or '')
    end,
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ' ',
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and (icons.git.Added .. ' ' .. count .. ' ')
    end,
    hl = { fg = 'git_add' },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and (icons.git.Removed .. ' ' .. count .. ' ')
    end,
    hl = { fg = 'git_delete' },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and (icons.git.Changed .. ' ' .. count .. ' ')
    end,
    hl = { fg = 'git_change' },
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ' ',
  },
  on_click = {
    name = 'heirline_git',
    callback = helpers.snacks_call(function(snacks)
      if not snacks.lazygit then
        return
      end

      local cwd = snacks.git and snacks.git.get_root and snacks.git.get_root() or nil
      if cwd then
        snacks.lazygit { cwd = cwd }
      else
        snacks.lazygit()
      end
    end),
  },
}

return M
