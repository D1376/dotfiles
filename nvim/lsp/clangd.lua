local function switch_source_header(bufnr, client)
  local method_name = 'textDocument/switchSourceHeader'
  if not client or not client:supports_method(method_name) then
    vim.notify(('method %s is not supported by any servers active on the current buffer'):format(method_name), vim.log.levels.WARN)
    return
  end

  local params = vim.lsp.util.make_text_document_params(bufnr)
  client:request(method_name, params, function(err, result)
    if err then
      vim.notify(err.message or vim.inspect(err), vim.log.levels.ERROR)
      return
    end

    if not result then
      vim.notify('No matching source/header file found', vim.log.levels.INFO)
      return
    end

    vim.cmd.edit(vim.uri_to_fname(result))
  end, bufnr)
end

local function symbol_info(bufnr, client)
  local method_name = 'textDocument/symbolInfo'
  if not client or not client:supports_method(method_name) then
    vim.notify('Clangd client not found', vim.log.levels.ERROR)
    return
  end

  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
  client:request(method_name, params, function(err, result)
    if err then
      vim.notify(err.message or vim.inspect(err), vim.log.levels.ERROR)
      return
    end

    if not result or vim.tbl_isempty(result) then
      vim.notify('No symbol info available', vim.log.levels.INFO)
      return
    end

    local lines = {}
    for index, symbol in ipairs(result) do
      if index > 1 then
        table.insert(lines, '')
      end
      table.insert(lines, '```')
      if symbol.name and symbol.name ~= '' then
        table.insert(lines, 'name: ' .. symbol.name)
      end
      if symbol.containerName and symbol.containerName ~= '' then
        table.insert(lines, 'container: ' .. symbol.containerName)
      end
      if symbol.usr and symbol.usr ~= '' then
        table.insert(lines, 'usr: ' .. symbol.usr)
      end
      if symbol.id and symbol.id ~= '' then
        table.insert(lines, 'id: ' .. symbol.id)
      end
      table.insert(lines, '```')
    end

    vim.lsp.util.open_floating_preview(lines, 'markdown', { border = vim.o.winborder })
  end, bufnr)
end

---@class ClangdInitializeResult: lsp.InitializeResult
---@field offsetEncoding? string

---@type vim.lsp.Config
return {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  root_markers = {
    '.clangd',
    '.clang-tidy',
    '.clang-format',
    'compile_commands.json',
    'compile_flags.txt',
    'configure.ac', -- AutoTools
    '.git',
  },
  get_language_id = function(_, ftype)
    local language_ids = { objc = 'objective-c', objcpp = 'objective-cpp', cuda = 'cuda-cpp' }
    return language_ids[ftype] or ftype
  end,
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { 'utf-8', 'utf-16' },
  },
  ---@param init_result ClangdInitializeResult
  on_init = function(client, init_result)
    if init_result.offsetEncoding then
      client.offset_encoding = init_result.offsetEncoding
    end
  end,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspClangdSwitchSourceHeader', function()
      switch_source_header(bufnr, client)
    end, { desc = 'Switch between source/header' })

    vim.api.nvim_buf_create_user_command(bufnr, 'LspClangdShowSymbolInfo', function()
      symbol_info(bufnr, client)
    end, { desc = 'Show symbol info' })
  end,
}
