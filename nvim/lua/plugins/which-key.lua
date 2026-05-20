local icons = require 'config.icons'

return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    preset = 'helix',
    delay = 0,
    icons = {
      -- set icon mappings to true if you have a Nerd Font
      -- breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
      -- separator = '➜', -- symbol used between a key and it's label
      -- group = '+', -- symbol prepended to a group
      -- ellipsis = '…',

      keys = {
        Up = '<Up>',
        Down = '<Down>',
        Left = '<Left>',
        Right = '<Right>',
        C = '<C-…>',
        M = '<M-…>',
        D = '<D-…>',
        S = '<S-…>',
        CR = '<CR>',
        Esc = '<Esc>',
        ScrollWheelDown = '󱕐',
        ScrollWheelUp = '󱕑',
        NL = '<NL>',
        BS = '<BS>',
        Space = '󱁐',
        Tab = '<Tab>',
        F1 = '<F1>',
        F2 = '<F2>',
        F3 = '<F3>',
        F4 = '<F4>',
        F5 = '<F5>',
        F6 = '<F6>',
        F7 = '<F7>',
        F8 = '<F8>',
        F9 = '<F9>',
        F10 = '<F10>',
        F11 = '<F11>',
        F12 = '<F12>',
      },
    },

    -- Document existing key chains
    spec = {
      { '<leader><space>', icon = icons.which_key_items.smart_files },
      { '<leader>,', icon = icons.which_key_items.buffers },
      { '<leader>/', icon = icons.which_key_items.grep },
      { '<leader>:', icon = icons.which_key_items.command_history },
      { '<leader>e', icon = icons.which_key_items.explorer },
      { '<leader>n', icon = icons.which_key_items.notifications },
      { '<leader>N', icon = icons.which_key_items.news },
      { '<leader>q', icon = icons.which_key_items.diagnostics },
      { '<leader>.', icon = icons.which_key_items.scratch },
      { '<leader>S', icon = icons.which_key_items.scratch_select },
      { '<leader>z', icon = icons.which_key_items.zen },
      { '<leader>Z', icon = icons.which_key_items.zoom },
      { '<leader>b', group = 'Buffer', icon = icons.which_key.buffer },
      { '<leader>c', group = 'Code', icon = icons.which_key.code },
      { '<leader>d', group = 'Debug', icon = icons.which_key.debug },
      { '<leader>g', group = 'Git', icon = icons.which_key.git },
      { '<leader>f', group = 'File/Find', icon = icons.which_key.file },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' }, icon = icons.which_key.hunk },
      { '<leader>l', group = 'Lsp', mode = 'n', icon = icons.which_key.lsp },
      { '<leader>s', group = 'Search', icon = icons.which_key.search },
      { '<leader>t', group = 'Toggle', icon = icons.which_key.toggle },
      { '<leader>u', group = 'UI', icon = icons.which_key.ui },
      { 'g', group = 'Go to', icon = icons.which_key['goto'] },
      { 'z', group = 'Fold', icon = icons.which_key.fold },
    },
  },
}
