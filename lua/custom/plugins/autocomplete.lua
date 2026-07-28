local M = {}

function M.setup()
  -- Require custom snippets (expanded via LuaSnip by typing the trigger + <Tab>).
  require 'custom.snippets.lua'
  require 'custom.snippets.python'
  require 'custom.snippets.cucumber'

  local luasnip = require 'luasnip'
  luasnip.config.setup {}
  require('luasnip.loaders.from_vscode').lazy_load()

  -- Native (built-in) insert-mode autocompletion is driven per-buffer by the
  -- LSP via vim.lsp.completion.enable (see custom.plugins.lsp), which triggers
  -- the popup as you type. "noinsert" pre-highlights the best match (without
  -- inserting) so a single <Tab> accepts it; snippet expansion/auto-imports
  -- apply on that <C-y>.
  vim.o.completeopt = 'menu,menuone,noinsert,fuzzy,popup'

  local feed = function(keys)
    vim.api.nvim_feedkeys(vim.keycode(keys), 'n', false)
  end

  -- <Tab>: expand a snippet at the cursor, otherwise accept the highlighted
  -- completion (applying LSP snippets/auto-imports via <C-y>), otherwise jump
  -- forward in an active snippet, otherwise insert a literal <Tab>.
  vim.keymap.set('i', '<Tab>', function()
    if luasnip.expandable() then
      luasnip.expand()
    elseif vim.fn.pumvisible() == 1 then
      feed '<C-y>'
    elseif luasnip.locally_jumpable(1) then
      luasnip.jump(1)
    else
      feed '<Tab>'
    end
  end, { desc = 'Complete / expand snippet' })

  vim.keymap.set('i', '<S-Tab>', function()
    if luasnip.locally_jumpable(-1) then
      luasnip.jump(-1)
    else
      feed '<S-Tab>'
    end
  end, { desc = 'Jump backward in snippet' })

  -- Navigate the completion menu.
  vim.keymap.set('i', '<C-j>', function()
    return vim.fn.pumvisible() == 1 and '<C-n>' or '<C-j>'
  end, { expr = true, desc = 'Next completion item' })
  vim.keymap.set('i', '<C-k>', function()
    return vim.fn.pumvisible() == 1 and '<C-p>' or '<C-k>'
  end, { expr = true, desc = 'Previous completion item' })

  -- Jump between snippet placeholders.
  vim.keymap.set({ 'i', 's' }, '<C-l>', function()
    if luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
    end
  end, { desc = 'Snippet: jump forward' })
  vim.keymap.set({ 'i', 's' }, '<C-h>', function()
    if luasnip.locally_jumpable(-1) then
      luasnip.jump(-1)
    end
  end, { desc = 'Snippet: jump backward' })

  -- Manually trigger completion.
  vim.keymap.set('i', '<C-Space>', function()
    vim.lsp.completion.get()
  end, { desc = 'Trigger completion' })
end

return M
