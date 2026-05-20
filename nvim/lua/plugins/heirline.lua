return {
  'rebelot/heirline.nvim',
  -- enabled = false,
  event = 'VimEnter',
  dependencies = {
    { 'echasnovski/mini.icons', opts = {} },
  },
  config = function()
    local utils = require 'heirline.utils'
    local colors = require 'plugins.heirline.colors'

    vim.opt.cmdheight = 0
    vim.opt.showcmdloc = 'statusline'

    require('heirline').setup {
      statusline = require 'plugins.heirline.statusline',
      opts = {
        colors = colors.setup,
      },
    }

    vim.api.nvim_create_augroup('HeirlineColors', { clear = true })
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = 'HeirlineColors',
      callback = function()
        utils.on_colorscheme(colors.setup)
        vim.cmd.redrawstatus()
      end,
    })
  end,
}
