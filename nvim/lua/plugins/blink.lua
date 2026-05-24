return {
  'saghen/blink.cmp',
  lazy = false,
  version = '1.*',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = 'make install_jsregexp',
      dependencies = {
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
      -- opts = {},
    },
  }, --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'enter',
      ['<C-y>'] = { 'select_and_accept' },
    },
    cmdline = { completion = { menu = { auto_show = true } } },
    completion = {
      -- menu = { border = 'rounded' },
      documentation = {
        window = {
          -- border = 'rounded',
        },
        auto_show = true,
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = true,
        },
      },
      menu = {
        draw = {
          columns = {
            { 'kind_icon' },
            { 'label', 'label_description', gap = 1 },
            { 'source_name' },
          },
        },
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
      providers = {
        lazydev = {
          module = 'lazydev.integrations.blink',
          score_offset = 100,
          enabled = function()
            return vim.bo.filetype == 'lua'
          end,
        },
      },
    },
    snippets = { preset = 'luasnip' },

    -- By default, we use the Lua implementation instead, but you may enable
    -- the rust implementation via `'prefer_rust_with_warning'`

    fuzzy = { implementation = 'lua' },

    -- Shows a signature help window while you type arguments for a function
    signature = {
      enabled = true,
      -- window = { border = 'rounded' },
    },
  },
  opts_extend = { 'sources.default' },
}
