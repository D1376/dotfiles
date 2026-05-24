---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    { '.emmyrc.json', '.luarc.json', '.luarc.jsonc' },
    { '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml' },
    '.git',
  },
  settings = {
    Lua = {
      codeLens = { enable = true },
      diagnostics = {
        disable = { 'missing-fields' },
        globals = {
          'vim',
          'Snacks',
        },
      },
      hint = {
        enable = true,
        paramName = 'Disable',
        paramType = true,
        semicolon = 'Disable',
        setType = false,
        arrayIndex = 'Disable',
      },
    },
  },
}
