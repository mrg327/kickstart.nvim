local M = {}

function M.setup()
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
  vim.keymap.set('n', '<leader>qi', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix [I]ssue list' })
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
  vim.keymap.set('n', '<leader>uft', 'za', { desc = '[F]olds: [T]oggle' })
  vim.keymap.set('n', '<leader>ufc', 'zc', { desc = '[F]olds: [C]lose' })
  vim.keymap.set('n', '<leader>ufo', 'zo', { desc = '[F]olds: [O]pen' })
  vim.keymap.set('n', '<leader>ufC', 'zM', { desc = '[F]olds: [C]lose all' })
  vim.keymap.set('n', '<leader>ufO', 'zR', { desc = '[F]olds: [O]pen all' })

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

  -- C/C++ build and run keybindings
  vim.keymap.set('n', '<leader>br', function()
    local ext = vim.fn.expand '%:e'
    local compiler, std, outname
    if ext == 'cpp' then
      compiler = 'g++'
      std = '-std=c++17'
      outname = vim.fn.expand '%:p:r'
    else
      compiler = 'gcc'
      std = '-std=c17'
      outname = vim.fn.expand '%:p:r'
    end
    local cmd = compiler .. ' ' .. std .. ' ' .. vim.fn.expand '%:p' .. ' -o ' .. outname
    vim.cmd.vsplit()
    vim.api.nvim_put({ cmd .. ' && echo "\n--- Output ---" && ' .. outname }, '', false, false)
    vim.cmd.term()
  end, { desc = '[B]uild and [R]un current C/C++ file' })

  vim.keymap.set('n', '<leader>bq', function()
    local ext = vim.fn.expand '%:e'
    local cmd
    if ext == 'cpp' then
      cmd = 'g++ -std=c++17 -Wall -Wextra -o /dev/null ' .. vim.fn.expand '%:p' .. ' 2>&1 | head -20'
    else
      cmd = 'gcc -std=c17 -Wall -Wextra -o /dev/null ' .. vim.fn.expand '%:p' .. ' 2>&1 | head -20'
    end
    local out = vim.fn.system(cmd)
    if out ~= '' then
      vim.cmd.copen()
      vim.fn.setqflist({}, 'x', { lines = vim.split(out, '\n') })
    else
      vim.notify('Compilation succeeded', vim.log.levels.INFO)
    end
  end, { desc = '[B]uild quick (errors in [Q]uickfix)' })
end

return M
