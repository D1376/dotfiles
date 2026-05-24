return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').install {
      'bash',
      'c',
      'css',
      'diff',
      'html',
      'javascript',
      'typescript',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'regex',
      'scss',
      'svelte',
      'tsx',
      'typst',
      'vim',
      'vimdoc',
      'vue',
    }
    vim.treesitter.language.register('bash', { 'zsh', 'fish' })
  end,
}
