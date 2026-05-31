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
  capabilities = blink.get_lsp_capabilities(capabilities, true)
end

vim.lsp.config('*', {
  capabilities = capabilities,
})

vim.lsp.enable {
  'lua_ls',
  'clangd',
  'basedpyright',
  'jdtls',
  'marksman',
  'ruff',
  'cmake',
  'vtsls',
  'tinymist',
}

vim.diagnostic.config {
  virtual_text = false,
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
