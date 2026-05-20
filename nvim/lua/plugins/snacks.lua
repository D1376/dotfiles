return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  ---@type snacks.Config
  opts = require 'plugins.snacks.opts',
  keys = require 'plugins.snacks.keys',
  init = function()
    require('plugins.snacks.toggles').setup()
  end,
}
