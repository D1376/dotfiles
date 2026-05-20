local severity = vim.diagnostic.severity

local capabilities = {
  textDocument = {
    semanticTokens = {
      multilineTokenSupport = true,
    },
  },
}

local ok, blink = pcall(require, 'blink.cmp')
if ok then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

vim.lsp.config('*', {
  capabilities = capabilities,
})

vim.lsp.enable {
  'lua_ls',
  'clangd',
  'pyright',
  'jdtls',
  'marksman',
  'ruff',
  'cmake',
}

vim.diagnostic.config {
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = true,
  },
  signs = {
    text = {
      [severity.ERROR] = '󰅚 ',
      [severity.WARN] = '󰀪 ',
      [severity.INFO] = '󰋽 ',
      [severity.HINT] = '󰌶 ',
    },
    numhl = {
      [severity.ERROR] = 'ErrorMsg',
      [severity.WARN] = 'WarningMsg',
    },
  },
}
