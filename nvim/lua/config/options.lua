vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.g.markdown_folding = 1
vim.g.simple_indicator_on = false
vim.g.snacks_animate = true

vim.filetype.add {
  extension = {
    mdx = 'markdown.mdx',
  },
}

vim.o.termguicolors = true
vim.o.winborder = 'rounded'
vim.o.pumborder = 'rounded'
vim.o.pummaxwidth = 80
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = true
vim.o.linebreak = true
vim.o.smoothscroll = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.laststatus = 3
vim.o.showtabline = 2
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes:1'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true

vim.o.autoindent = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.smartindent = true

vim.opt.jumpoptions = { 'clean', 'view' }
vim.opt.listchars = {
  tab = '» ',
  trail = '·',
  nbsp = '␣',
}

-- Sync clipboard between OS and Neovim.
-- Schedule the setting because it can increase startup time.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
