local M = {}

local function github(repository)
  return {
    src = 'https://github.com/' .. repository,
  }
end

local function run_build(command, path)
  local result = vim.system(command, { cwd = path }):wait()
  if result.code ~= 0 then
    vim.notify(
      ('Build failed in %s:\n%s'):format(path, result.stderr),
      vim.log.levels.ERROR
    )
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
      if name == 'LuaSnip' and vim.fn.has('win32') == 0 and vim.fn.executable('make') == 1 then
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
  github('tpope/vim-sleuth'),
  github('hrsh7th/nvim-cmp'),
  github('L3MON4D3/LuaSnip'),
  github('rafamadriz/friendly-snippets'),
  github('saadparwaiz1/cmp_luasnip'),
  github('hrsh7th/cmp-nvim-lsp'),
  github('hrsh7th/cmp-path'),
  github('onsails/lspkind-nvim'),
  github('stevearc/conform.nvim'),
  github('folke/tokyonight.nvim'),
  github('mfussenegger/nvim-dap'),
  github('nvim-neotest/nvim-nio'),
  github('rcarriga/nvim-dap-ui'),
  github('mfussenegger/nvim-dap-python'),
  github('theHamsta/nvim-dap-virtual-text'),
  github('luckasRanarison/nvim-devdocs'),
  github('nvim-lua/plenary.nvim'),
  github('nvim-telescope/telescope.nvim'),
  github('lewis6991/gitsigns.nvim'),
  github('folke/lazydev.nvim'),
  github('nomnivore/ollama.nvim'),
  github('williamboman/mason.nvim'),
  github('WhoIsSethDaniel/mason-tool-installer.nvim'),
  github('j-hui/fidget.nvim'),
  github('MeanderingProgrammer/render-markdown.nvim'),
  github('echasnovski/mini.nvim'),
  github('epwalsh/obsidian.nvim'),
  github('mrcjkb/rustaceanvim'),
  github('folke/snacks.nvim'),
  github('folke/todo-comments.nvim'),
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main',
  },
  github('nvzone/typr'),
  github('nvzone/volt'),
  github('lervag/vimtex'),
  github('folke/which-key.nvim'),
}

local modules = {
  'colorscheme',
  'mini',
  'snacks',
  'whichkey',
  'todo',
  'gitsigns',
  'lazydev',
  'llm',
  'lsp',
  'autocomplete',
  'autoformat',
  'debug',
  'devdocs',
  'markdown-render',
  'obsidian',
  'rustacean',
  'treesitter',
  'typr',
  'vimtex',
}

local setup_with_opts = {
  ['stevearc/conform.nvim'] = 'conform',
  ['luckasRanarison/nvim-devdocs'] = 'nvim-devdocs',
  ['lewis6991/gitsigns.nvim'] = 'gitsigns',
  ['folke/lazydev.nvim'] = 'lazydev',
  ['nomnivore/ollama.nvim'] = 'ollama',
  ['MeanderingProgrammer/render-markdown.nvim'] = 'render-markdown',
  ['epwalsh/obsidian.nvim'] = 'obsidian',
  ['folke/snacks.nvim'] = 'snacks',
  ['folke/todo-comments.nvim'] = 'todo-comments',
  ['folke/which-key.nvim'] = 'which-key',
  ['nvzone/typr'] = 'typr',
}

local function spec_for(module)
  local spec = require('custom.plugins.' .. module)
  if type(spec[1]) == 'table' then
    return spec[1]
  end
  return spec
end

local function install_keys(keys)
  for _, key in ipairs(keys or {}) do
    local modes = key.mode or 'n'
    local options = vim.tbl_extend('force', {}, key)
    options[1] = nil
    options[2] = nil
    options.mode = nil
    vim.keymap.set(modes, key[1], key[2], options)
  end
end

local function configure(module)
  local spec = spec_for(module)
  if spec.config then
    spec.config()
  elseif spec.opts then
    local plugin = setup_with_opts[spec[1]]
    if not plugin then
      error('No native setup handler registered for ' .. spec[1])
    end
    local options = spec.opts
    if type(options) == 'function' then
      options = options()
    end
    if options == nil then
      return
    end
    require(plugin).setup(options)
  end
  install_keys(spec.keys)
  if spec.init then
    spec.init()
  end
end

function M.setup()
  vim.g.vimtex_view_method = 'general'
  vim.g.vimtex_view_general_viewer = 'okular'
  local treesitter_update_needed = configure_builds()
  vim.pack.add(packages, { confirm = false, load = true })
  if treesitter_update_needed() and vim.fn.exists(':TSUpdate') == 2 then
    vim.schedule(function()
      local ok, error_message = pcall(vim.cmd, 'TSUpdate')
      if not ok then
        vim.notify(error_message, vim.log.levels.WARN)
      end
    end)
  end

  for _, module in ipairs(modules) do
    configure(module)
  end

  require('luasnip.loaders.from_vscode').lazy_load()
  require('luasnip').filetype_extend('htmldjango', { 'html' })
  vim.api.nvim_exec_autocmds('User', { pattern = 'VeryLazy' })
end

return M
