return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  config = function()
    require("oil").setup()
    -- Oil File Browser Keymaps
    vim.keymap.set('n', '<leader>of', "<cmd>Oil<CR>", {desc = 'Open [O]pen [F]ile Browser'})
  end
}
