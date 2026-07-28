local M = {}

local function github(repository)
  return {
    src = 'https://github.com/' .. repository,
  }
end

local function run_build(command, path)
  local result = vim.system(command, { cwd = path }):wait()
  if result.code ~= 0 then
    vim.notify(('Build failed in %s:\n%s'):format(path, result.stderr), vim.log.levels.ERROR)
  end
end

local function configure_builds()
  local treesitter_update_needed = false
  vim.api.nvim_create_autocmd('PackChanged', {
    group = vim.api.nvim_create_augroup('custom-package-builds', { clear = true }),
    callback = function(event)
      if event.data.kind ~= 'install' and event.data.kind ~= 'update' then
        return
      end

      local name = event.data.spec.name
      if name == 'LuaSnip' and vim.fn.has 'win32' == 0 and vim.fn.executable 'make' == 1 then
        run_build({ 'make', 'install_jsregexp' }, event.data.path)
      elseif name == 'nvim-treesitter' then
        treesitter_update_needed = true
      end
    end,
  })
  return function()
    return treesitter_update_needed
  end
end

local packages = {
  github 'tpope/vim-sleuth',
  github 'L3MON4D3/LuaSnip',
  github 'rafamadriz/friendly-snippets',
  github 'stevearc/conform.nvim',
  github 'folke/tokyonight.nvim',
  github 'mfussenegger/nvim-dap',
  github 'nvim-neotest/nvim-nio',
  github 'rcarriga/nvim-dap-ui',
  github 'mfussenegger/nvim-dap-python',
  github 'theHamsta/nvim-dap-virtual-text',
  github 'nvim-lua/plenary.nvim',
  github 'lewis6991/gitsigns.nvim',
  github 'folke/lazydev.nvim',
  github 'williamboman/mason.nvim',
  github 'WhoIsSethDaniel/mason-tool-installer.nvim',
  github 'j-hui/fidget.nvim',
  github 'MeanderingProgrammer/render-markdown.nvim',
  github 'echasnovski/mini.nvim',
  github 'folke/snacks.nvim',
  github 'folke/todo-comments.nvim',
  github 'nvim-neotest/neotest',
  github 'nvim-neotest/neotest-python',
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main',
  },
  github 'folke/which-key.nvim',
}

local modules = {
  'colorscheme',
  'mini',
  'snacks',
  'whichkey',
  'todo',
  'gitsigns',
  'lazydev',
  'lsp',
  'autocomplete',
  'autoformat',
  'debug',
  'markdown-render',
  'neotest',
  'treesitter',
}

function M.setup()
  local treesitter_update_needed = configure_builds()
  vim.pack.add(packages, { confirm = false, load = true })
  if treesitter_update_needed() and vim.fn.exists ':TSUpdate' == 2 then
    vim.schedule(function()
      local ok, error_message = pcall(vim.cmd, 'TSUpdate')
      if not ok then
        vim.notify(error_message, vim.log.levels.WARN)
      end
    end)
  end

  for _, module in ipairs(modules) do
    require('custom.plugins.' .. module).setup()
  end
end

return M
