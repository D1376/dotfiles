return {
  'nvimdev/lspsaga.nvim',
  event = 'VeryLazy',
  opts = {
    symbol_in_winbar = {
      enable = true,
      separator = ' › ',
      hide_keyword = true,
      folder_level = 1,
    },
    outline = {
      enable = false,
    },
    lightbulb = {
      enable = false,
    },
    code_action = {
      enable = false,
    },
  },
}
