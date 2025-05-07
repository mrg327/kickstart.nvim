return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {

    {"<leader>bl", function() vim.cmd "ObsidianLink" end, desc = "O[B]sidian [l]ink", mode="v"},
    {"<leader>bL", function() vim.cmd "ObsidianLinkNew" end, desc = "O[B]sidian [L]ink New", mode="v"},
    {"<leader>bf", function() vim.cmd "ObsidianFollowLink" end, desc = "O[B]sidian [f]ollow link"},
    {"<leader>br", function() vim.cmd "ObsidianFollowLink" end, desc = "O[B]sidian [f]ollow link"},
    {"<leader>bs", function() vim.cmd "ObsidianBacklinks" end, desc = "O[B]sidian [S]earch Links"},
  },
  opts = {
    workspaces = {
      {
        name = "metrophyre",
        path = "E:\\DnD\\metrophyre",
      },
    },
  },
  -- Use only the alias (i.e. the note’s title) for wiki links:
  wiki_link_func = "use_alias_only",
}
