local colored_fts = {
  'cfg',
  'css',
  'html',
  'conf',
  'lua',
  'scss',
  'toml',
  'tmux',
  'xml',
  'kitty',
  'markdown',
  'python',
  'typescript',
  'typescriptreact',
}

return {
  {
    'brenoprata10/nvim-highlight-colors',
    ft = colored_fts,
    keys = {
      { ',c', '<cmd>HighlightColors Toggle<cr>', silent = true, desc = 'Toggle colorizer' },
    },
    opts = {
      render = 'virtual',
      virtual_symbol = '󱓻',
    },
  },
}
