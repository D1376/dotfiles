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
      preset = 'super-tab',
      ['<C-d>'] = { 'show_documentation', 'hide_documentation', 'fallback' },
      ['<C-y>'] = { 'select_and_accept', 'fallback' },
    },
    cmdline = { completion = { menu = { auto_show = true } } },
    completion = {
      trigger = {
        show_in_snippet = false,
      },
      -- menu = { border = 'rounded' },
      documentation = {
        auto_show = false,
        treesitter_highlighting = false,
        window = {
          -- border = 'rounded',
        },
      },
      list = {
        max_items = 100,
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
      default = { 'lsp', 'path', 'snippets', 'lazydev' },
      providers = {
        lsp = {
          async = true,
          timeout_ms = 80,
          fallbacks = {},
        },
        path = {
          opts = {
            get_cwd = function()
              return vim.fn.getcwd()
            end,
          },
        },
        snippets = {
          max_items = 20,
          min_keyword_length = 2,
        },
        buffer = {
          max_items = 30,
          min_keyword_length = 3,
        },
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

    fuzzy = {
      implementation = 'prefer_rust_with_warning',
      sorts = { 'exact', 'score', 'sort_text' },
    },

    signature = {
      enabled = false,
    },
  },
  opts_extend = { 'sources.default' },
}
