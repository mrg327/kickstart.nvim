-- Use `opts = {}` to force a plugin to be loaded.
--

-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
--    require('gitsigns').setup({ ... })
--
-- See `:help gitsigns` to understand what the configuration keys do
return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(buffer)
      local gitsigns = require 'gitsigns'
      local map = function(mode, lhs, rhs, options)
        options = vim.tbl_extend('force', { buffer = buffer }, options or {})
        vim.keymap.set(mode, lhs, rhs, options)
      end

      map('n', ']c', function()
        if vim.wo.diff then
          return ']c'
        end
        vim.schedule(gitsigns.next_hunk)
        return '<Ignore>'
      end, { expr = true })
      map('n', '[c', function()
        if vim.wo.diff then
          return '[c'
        end
        vim.schedule(gitsigns.prev_hunk)
        return '<Ignore>'
      end, { expr = true })
      map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Git [S]tage hunk' })
      map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Git [R]eset hunk' })
      map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Git [S]tage buffer' })
      map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'Git [U]ndo stage hunk' })
      map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Git [R]eset buffer' })
      map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Git [P]review hunk' })
      map('n', '<leader>hb', gitsigns.blame_line, { desc = 'Git [B]lame line' })
      map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Git [D]iff against index' })
    end,
  },
}
