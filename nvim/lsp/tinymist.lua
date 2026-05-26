---@type vim.lsp.Config
return {
  cmd = { 'tinymist' },
  filetypes = { 'typst' },
  root_markers = { '.git', 'typst.toml' },
  settings = {
    exportPdf = 'onType',
    formatterMode = 'typstyle',
    semanticTokens = 'enable',
  },
}
