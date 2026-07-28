local M = {}

function M.setup()
  local highlight_group = vim.api.nvim_create_augroup('custom-lsp-highlight', { clear = false })
  local detach_group = vim.api.nvim_create_augroup('custom-lsp-detach', { clear = true })

  vim.api.nvim_create_autocmd('LspDetach', {
    group = detach_group,
    callback = function(event)
      vim.lsp.buf.clear_references()
      for _, client in pairs(vim.lsp.get_clients { bufnr = event.buf }) do
        if client.id ~= event.data.client_id and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          return
        end
      end
      vim.api.nvim_clear_autocmds {
        group = highlight_group,
        buffer = event.buf,
      }
    end,
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('custom-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
      map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        local existing_highlights = vim.api.nvim_get_autocmds {
          group = highlight_group,
          buffer = event.buf,
          event = 'CursorHold',
        }
        if #existing_highlights == 0 then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_group,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end

      if client and client.name == 'ruff' then
        client.server_capabilities.hoverProvider = false
      end

      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
        -- Autotrigger native completion on every keypress, not only on the
        -- server-defined trigger characters.
        local provider = client.server_capabilities.completionProvider or {}
        local triggers = provider.triggerCharacters or {}
        for byte = ('a'):byte(), ('z'):byte() do
          table.insert(triggers, string.char(byte))
        end
        for byte = ('A'):byte(), ('Z'):byte() do
          table.insert(triggers, string.char(byte))
        end
        table.insert(triggers, '_')
        provider.triggerCharacters = triggers
        client.server_capabilities.completionProvider = provider
        vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
      end

      if client and vim.bo[event.buf].filetype == 'python' and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
      end

      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  vim.lsp.config('*', { capabilities = capabilities })

  local venv = require 'custom.venv'

  local python_root_markers = {
    'pyrightconfig.json',
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    '.git',
  }

  local servers = {
    basedpyright = {
      cmd = { 'basedpyright-langserver', '--stdio' },
      filetypes = { 'python' },
      root_markers = python_root_markers,
      before_init = function(_, config)
        local python = venv.python(config.root_dir)
        if python then
          config.settings = config.settings or {}
          config.settings.python = config.settings.python or {}
          config.settings.python.pythonPath = python
        end
      end,
      settings = {
        basedpyright = {
          disableOrganizeImports = true,
          analysis = {
            typeCheckingMode = 'basic',
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          },
        },
      },
    },
    ruff = {
      cmd = { 'ruff', 'server' },
      filetypes = { 'python' },
      root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
      init_options = {
        settings = {
          organizeImports = true,
          fixAll = true,
        },
      },
      on_attach = function(client)
        client.server_capabilities.hoverProvider = false
      end,
    },
    cucumber_language_server = {
      cmd = { 'cucumber-language-server', '--stdio' },
      filetypes = { 'cucumber' },
      root_markers = { '.git' },
      settings = {
        cucumber = {
          features = { '**/features/**/*.feature', '**/features/*.feature' },
          glue = {
            '**/tests/step_defs/**/*.py',
            '**/tests/step_defs/*.py',
            'tests/step_defs/*.py',
          },
        },
      },
    },
    html = {
      cmd = { 'vscode-html-language-server', '--stdio' },
      filetypes = { 'html' },
      root_markers = { 'package.json', '.git' },
      init_options = {
        provideFormatter = true,
        embeddedLanguages = { css = true, javascript = true },
        configurationSection = { 'html', 'css', 'javascript' },
      },
    },
    lua_ls = {
      cmd = { 'lua-language-server' },
      filetypes = { 'lua' },
      root_markers = {
        { '.emmyrc.json', '.luarc.json', '.luarc.jsonc' },
        { '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml' },
        { '.git' },
      },
      settings = {
        Lua = {
          completion = { callSnippet = 'Replace' },
          checkThirdParty = false,
          telemetry = { enable = false },
          diagnostics = { disable = { 'missing-fields' } },
        },
      },
    },
  }

  require('fidget').setup {}
  require('mason').setup()
  require('mason-tool-installer').setup {
    ensure_installed = {
      'basedpyright',
      'ruff',
      'cucumber-language-server',
      'html-lsp',
      'lua-language-server',
      'stylua',
    },
  }

  for name, config in pairs(servers) do
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  end
end

return M
