return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app; npm install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  ft = { "markdown" },
  keys = {
    {"<leader>mp", function() vim.cmd "MarkdownPreview" end, desc = "[M]arkdown [P]review"},
    {"<leader>mP", function() vim.cmd "MarkdownPreviewStop" end, desc = "Stop [M]arkdown [P]review"},
  },
}
