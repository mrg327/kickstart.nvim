local M = {}

function M.setup()
  require('todo-comments').setup { signs = false }
  vim.keymap.set('n', '<leader>qt', function()
    vim.cmd('TodoQuickFix cwd=' .. vim.fn.expand '%:p:h')
  end, { desc = 'Open diagnostic [Q]uickfix [T]odo list' })
end

return M
