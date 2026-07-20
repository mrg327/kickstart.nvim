return { -- Parser management only; highlighting & indent use Neovim 0.12 built-ins
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup()

    -- Neovim 0.12 auto-enables treesitter for lua, markdown, help, query.
    -- Enable built-in treesitter highlighting + indent for all other filetypes.
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('UserTreesitter', { clear = true }),
      callback = function(ev)
        local buf = ev.buf
        local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
        if vim.treesitter.highlighter.active[buf] then
          return
        end
        local ok = pcall(vim.treesitter.start, buf, lang)
        if ok and ev.match ~= 'ruby' then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
