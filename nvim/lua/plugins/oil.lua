return {
  'stevearc/oil.nvim',
  cmd = 'Oil',
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  opts = {
    keymaps = {
      ['<C-h>'] = false,
      ['<C-l>'] = false,
      ['<C-k>'] = false,
      ['<C-j>'] = false,
      ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
      ['<C-s>'] = { 'actions.select', opts = { horizontal = true } },
      ['<C-r>'] = 'actions.refresh',
      ['<BS>'] = { 'actions.parent', mode = 'n' },
      ['q'] = { 'actions.close', mode = 'n' },
      ['<leader>e'] = { 'actions.close', mode = 'n' },
    },
    -- Configuration for the floating window in oil.open_float
    float = {
      border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    },
  },
  keys = {
    { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
    { '<leader>e', '<cmd>Oil --float<cr>', desc = 'File Explorer' },
  },
}
