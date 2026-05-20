return {
  'catppuccin/nvim',
  -- enabled = false,
  name = 'catppuccin',
  lazy = false,
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    require('catppuccin').setup {
      transparent_background = true, -- disables setting the background color.
      float = {
        transparent = true, -- enable transparent floating windows
        solid = false, -- use solid styling for floating windows, see |winborder|
      },
      show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
      dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = 'dark',
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
      },
      -- no_underline = true, -- Force no underline
      -- no_italic = true, -- Force no italic
      auto_integrations = true,
      integrations = {
        treesitter = true,
        notify = true,
        noice = true,
        dashboard = true,
        flash = true,
        lsp_saga = true,
        mason = true,
        notifier = true,
        which_key = true,
        snacks = {
          enabled = true,
          indent_scope_color = '', -- catppuccin color (eg. `lavender`) Default: text
        },
        gitsigns = {
          enabled = true,
          transparent = true,
        },
        mini = {
          enabled = true,
          indentscope_color = '',
        },
        blink_cmp = {
          style = 'bordered',
        },
      },
    }
    vim.cmd.colorscheme 'catppuccin'
  end,
}
