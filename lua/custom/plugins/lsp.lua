return {
  'native-lsp',
  config = function()
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
          local group = vim.api.nvim_create_augroup('custom-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = group,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            buffer = event.buf,
            group = vim.api.nvim_create_augroup('custom-lsp-detach', { clear = true }),
            callback = function(detach_event)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds {
                group = 'custom-lsp-highlight',
                buffer = detach_event.buf,
              }
            end,
          })
        end

        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    local capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())
    vim.lsp.config('*', { capabilities = capabilities })

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
      pyright = {
        cmd = { 'pyright-langserver', '--stdio' },
        filetypes = { 'python' },
        root_markers = python_root_markers,
        settings = {
          pyright = { disableOrganizeImports = true },
          python = {
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
      ast_grep = {
        cmd = { 'ast-grep', 'lsp' },
        filetypes = {
          'bash',
          'c',
          'cpp',
          'cs',
          'css',
          'elixir',
          'go',
          'haskell',
          'html',
          'java',
          'javascript',
          'javascriptreact',
          'json',
          'kotlin',
          'lua',
          'nix',
          'php',
          'python',
          'ruby',
          'rust',
          'scala',
          'solidity',
          'swift',
          'typescript',
          'typescriptreact',
          'yaml',
        },
        root_markers = { 'sgconfig.yaml', 'sgconfig.yml' },
        workspace_required = true,
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
        'pyright',
        'ruff',
        'cucumber-language-server',
        'html-lsp',
        'ast-grep',
        'lua-language-server',
        'stylua',
      },
    }

    for name, config in pairs(servers) do
      vim.lsp.config(name, config)
      vim.lsp.enable(name)
    end
  end,
}
