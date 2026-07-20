local environment = require('custom.environment').get()

if environment.shell then
  vim.o.shell = environment.shell
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

if environment.python then
  vim.g.python3_host_prog = environment.python
end

vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.swapfile = false

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>qi', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix [I]ssue list' })
vim.keymap.set('n', '<leader>qt', function()
  vim.cmd('TodoQuickFix cwd=' .. vim.fn.expand '%:p:h')
end, { desc = 'Open diagnostic [Q]uickfix [T]odo list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>U', function()
  vim.cmd.packadd 'nvim.undotree'
  require('undotree').open()
end, { desc = 'Open native undo tree' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  pattern = '*.md',
  callback = function()
    if vim.bo.modified then
      vim.cmd 'silent! write'
    end
  end,
  desc = 'Auto-save Markdown files after inactivity',
})

local views = vim.api.nvim_create_augroup('persistent-views', { clear = true })
local function is_file_buffer(buffer)
  return vim.bo[buffer].buftype == '' and vim.api.nvim_buf_get_name(buffer) ~= ''
end

vim.api.nvim_create_autocmd('BufWritePost', {
  group = views,
  callback = function(event)
    if is_file_buffer(event.buf) then
      vim.cmd 'mkview'
    end
  end,
})
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = views,
  callback = function(event)
    if is_file_buffer(event.buf) then
      vim.cmd 'silent! loadview'
    end
  end,
})
vim.api.nvim_create_autocmd('BufReadPost', {
  group = views,
  callback = function()
    if vim.bo.filetype ~= 'commit' and vim.fn.line [['"]] > 1 and vim.fn.line [['"]] <= vim.fn.line '$' then
      vim.cmd 'normal! g`"zv'
    end
  end,
})

vim.keymap.set('n', '<C-s>', '<cmd>w<CR>')
vim.keymap.set('i', '<C-s>', '<cmd>w<CR>')
vim.keymap.set('n', '<leader>cd', function()
  vim.cmd 'cd %:p:h'
end, { desc = '[C]hange Working [D]irectory to Active Buffer' })
vim.keymap.set('n', '<leader>ccd', function()
  vim.cmd 'lcd %:p:h'
end, { desc = '[C]hange [C]urrent Working [D]irectory to Active Buffer' })
vim.keymap.set('n', '<F6>', '<cmd>term<CR>', { desc = 'Create a terminal' })
vim.keymap.set('n', '<F7>', '<cmd>tabnew<CR>', { desc = 'Create a tab' })
vim.keymap.set('n', '<S-F7>', '<cmd>tabclose<CR>', { desc = 'Close a tab' })
vim.keymap.set('n', '<C-S-F7>', '<cmd>bd!<CR>', { desc = 'Delete a buffer' })

vim.keymap.set('n', '<M-s>', '<C-w>s', { desc = '[S]plit the current buffer' })
vim.keymap.set('n', '<M-v>', '<C-w>v', { desc = '[V]ertically split the current buffer' })
vim.keymap.set('n', '<M-o>', '<C-w>o', { desc = 'Show [O]nly the active buffer' })
vim.keymap.set('n', '<M-=>', '<C-w>=', { desc = 'Set buffers to equal size' })

require('custom.packages').setup()
