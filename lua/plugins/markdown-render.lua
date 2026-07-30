local M = {}

function M.setup()
  require('render-markdown').setup {
    file_types = { 'markdown' },
    completions = { lsp = { enabled = true } },
  }
end

return M
