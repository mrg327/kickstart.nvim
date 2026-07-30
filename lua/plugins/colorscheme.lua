local M = {}

function M.setup()
  vim.cmd.colorscheme 'tokyonight-night'
  vim.cmd.hi 'Comment gui=none'
end

return M
