local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
map('i', 'jk', '<ESC>', { silent = true })

map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic location list' })

map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })
map('t', '<c-_>', '<cmd>close<cr>', { desc = 'which_key_ignore' })

map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

map('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
map('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
map('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
map('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })

map('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename' })
map({ 'n', 'x' }, 'ga', vim.lsp.buf.code_action, { desc = 'Goto Code Action' })
