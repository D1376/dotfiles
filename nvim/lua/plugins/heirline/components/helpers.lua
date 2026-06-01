local icons = require 'config.icons'

local M = {}
local formatter_cache = {}

function M.buf_option(bufnr, name)
  return vim.api.nvim_get_option_value(name, { buf = bufnr or 0 })
end

function M.highlight_fg(name, fallback)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if ok and hl and hl.fg then
    return ('#%06x'):format(hl.fg)
  end
  return fallback
end

function M.get_mini_icon(filename, buftype)
  if buftype == 'terminal' then
    return icons.status.Terminal, 'cyan'
  end

  local ok, mini_icons = pcall(require, 'mini.icons')
  if not ok then
    return icons.status.DefaultFile, 'dim'
  end

  local icon, hl = mini_icons.get('file', filename ~= '' and filename or 'file')
  return icon, M.highlight_fg(hl, 'file')
end

function M.snacks_call(callback)
  return function()
    local snacks = rawget(_G, 'Snacks')
    if snacks then
      callback(snacks)
    end
  end
end

local function formatter_cache_key(bufnr)
  local names = {}
  for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
    names[#names + 1] = client.name
  end
  table.sort(names)

  return table.concat({
    M.buf_option(bufnr, 'filetype'),
    vim.fn.getcwd(),
    table.concat(names, ','),
  }, '\n')
end

function M.formatter_labels(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local key = formatter_cache_key(bufnr)
  local cached = formatter_cache[bufnr]
  if cached and cached.key == key then
    return cached.labels
  end

  local ok, conform = pcall(require, 'conform')
  if not ok then
    return {}
  end

  local ok_list, formatters, has_lsp = pcall(conform.list_formatters_to_run, bufnr)
  if not ok_list then
    return {}
  end

  local labels = {}
  for _, formatter in ipairs(formatters) do
    labels[#labels + 1] = formatter.name or formatter
  end

  if has_lsp then
    labels[#labels + 1] = 'lsp'
  end

  formatter_cache[bufnr] = { key = key, labels = labels }
  return labels
end

return M
