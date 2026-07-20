local function options()
  local vault = require('custom.environment').get().obsidian_loc
  if not vault then
    return nil
  end

  local opts = {
    note_id_func = function(title)
      if title and title ~= '' then
        return title:gsub('%s+', '-'):gsub('[^A-Za-z0-9%-]', ''):lower()
      end
      return tostring(os.time())
    end,
    note_path_func = function(spec)
      return (spec.dir / spec.id):with_suffix '.md'
    end,
    wiki_link_func = 'use_alias_only',
  }

  opts.workspaces = {
    { name = 'default', path = vault },
  }
  return opts
end

return {
  'epwalsh/obsidian.nvim',
  version = '*',
  lazy = true,
  ft = 'markdown',
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {

    {
      '<leader>bl',
      function()
        vim.cmd 'ObsidianLink'
      end,
      desc = 'O[B]sidian [l]ink',
      mode = 'v',
    },
    {
      '<leader>bL',
      function()
        vim.cmd 'ObsidianLinkNew'
      end,
      desc = 'O[B]sidian [L]ink New',
      mode = 'v',
    },
    {
      '<leader>bf',
      function()
        vim.cmd 'ObsidianFollowLink'
      end,
      desc = 'O[B]sidian [f]ollow link',
    },
    {
      '<leader>bs',
      function()
        vim.cmd 'ObsidianBacklinks'
      end,
      desc = 'O[B]sidian [S]earch Links',
    },
  },
  opts = options,
}
