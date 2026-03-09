-- NOTE: First-time setup requires running :DevdocsFetch once to download the registry,
-- then :DevdocsInstall to pick docs (or ensure_installed handles it on next launch).
return {
  'luckasRanarison/nvim-devdocs',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  cmd = {
    'DevdocsFetch',
    'DevdocsInstall',
    'DevdocsUninstall',
    'DevdocsOpen',
    'DevdocsOpenFloat',
    'DevdocsOpenCurrent',
    'DevdocsOpenCurrentFloat',
    'DevdocsToggle',
    'DevdocsUpdate',
    'DevdocsUpdateAll',
  },
  keys = {
    { '<leader>dd', '<cmd>DevdocsOpenCurrentFloat<CR>', desc = '[D]ev[D]ocs for current filetype' },
    { '<leader>dD', '<cmd>DevdocsOpenFloat<CR>', desc = '[D]ev[D]ocs search all' },
    { '<leader>di', '<cmd>DevdocsInstall<CR>', desc = '[D]evdocs [I]nstall' },
    { '<leader>dt', '<cmd>DevdocsToggle<CR>', desc = '[D]evdocs [T]oggle' },
  },
  opts = {
    -- Maps neovim filetypes to devdocs doc name prefixes.
    -- The plugin uses these to find all installed variant versions
    -- (e.g. "python" matches "python-3.12", "python-3.11", etc.)
    filetypes = {
      python = 'python',
      lua = 'lua',
      typescript = { 'typescript', 'node' },
      rust = 'rust',
      c = 'c',
      cpp = 'cpp',
    },
    float_win = {
      relative = 'editor',
      height = 25,
      width = 100,
      border = 'rounded',
    },
    wrap = true,
    -- Aliases use dashes: e.g. "python-3.12", "lua-5.4"
    -- These auto-install after registry is fetched (requires :DevdocsFetch first)
    ensure_installed = {
      'python-3.12',
      'lua-5.4',
      'html',
      'css',
      'bash',
    },
    after_open = function(bufnr)
      vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = bufnr, desc = 'Close devdocs window' })
    end,
  },
}
