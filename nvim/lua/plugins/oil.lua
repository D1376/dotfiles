return {
  'stevearc/oil.nvim',
  lazy = false,
  cmd = 'Oil',
  dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
  opts = {
    default_file_explorer = true,
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
      ['<leader>-'] = { 'actions.close', mode = 'n' },
    },
    -- Configuration for the floating window in oil.open_float
    float = {
      border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    },
  },
  keys = {
    { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
    { '<leader>-', '<cmd>Oil --float<cr>', desc = 'File Explorer' },
  },
}
