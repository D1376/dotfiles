local icons = require 'config.icons'

local M = {}

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

function M.formatter_labels()
  local ok, conform = pcall(require, 'conform')
  if not ok then
    return {}
  end

  local ok_list, formatters, has_lsp = pcall(conform.list_formatters_to_run, 0)
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

  return labels
end

return M
