local M = {}

function M.setup()
  require('conform').setup {
    notify_on_error = false,
    format_on_save = function(buffer)
      return {
        timeout_ms = 3000,
        lsp_format = ({ c = true, cpp = true })[vim.bo[buffer].filetype] and 'never' or 'fallback',
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
      cpp = { 'clang_format' },
      c = { 'clang_format' },
    },
  }
  vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
    require('conform').format { async = true, lsp_format = 'fallback' }
  end, { desc = '[F]ormat buffer' })
end

return M
