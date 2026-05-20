local lazypath = vim.fs.joinpath(vim.fn.stdpath 'data', 'lazy', 'lazy.nvim')

if not vim.uv.fs_stat(lazypath) then
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
  local result = vim.system(clone_cmd, { text = true }):wait()

  if result.code ~= 0 then
    local message = result.stderr and result.stderr ~= '' and result.stderr or result.stdout or ''
    error(('Error cloning lazy.nvim:\n%s'):format(message))
  end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  spec = {
    { import = 'plugins' },
  },
  install = { colorscheme = { 'catppuccin', 'habamax' } },
  checker = { enabled = false },
}
