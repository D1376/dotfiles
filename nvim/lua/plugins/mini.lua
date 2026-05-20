-- Collection of various small independent plugins/modules
return {
  'echasnovski/mini.nvim',
  event = 'VeryLazy',
  config = function()
    -- mini.surround
    require('mini.surround').setup {}

    -- mini.icons
    require('mini.icons').setup {
      style = 'glyph',

      file = {
        README = { glyph = '', hl = 'MiniIconsYellow' },
        ['README.md'] = { glyph = '', hl = 'MiniIconsYellow' },
        ['README.txt'] = { glyph = '', hl = 'MiniIconsYellow' },
      },

      filetype = {
        dotenv = { glyph = '', hl = 'MiniIconsYellow' },
        bash = { glyph = '󱆃', hl = 'MiniIconsGreen' },
        sh = { glyph = '󱆃', hl = 'MiniIconsGrey' },
        toml = { glyph = '󱄽', hl = 'MiniIconsOrange' },
      },
    }

    require('mini.tabline').setup {
      show_icons = true,
      format = function(buf_id, label)
        local MiniTabline = require('mini.tabline').default_format(buf_id, label)
        return string.format(' %s ', MiniTabline)
      end,
    }
  end,
}

-- Better Around/Inside textobjects
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
-- require('mini.ai').setup { n_lines = 500 }

-- Add/delete/replace surroundings (brackets, quotes, etc.)
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
-- require('mini.diff').setup()
