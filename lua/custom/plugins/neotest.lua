local M = {}

function M.setup()
  local neotest = require 'neotest'

  neotest.setup {
    adapters = {
      -- pytest runs both the plain unittest.TestCase suites and pytest-style
      -- tests in this workflow. The virtualenv is auto-detected from .venv.
      require 'neotest-python' {
        runner = 'pytest',
        dap = { justMyCode = false },
      },
    },
  }

  local map = function(lhs, fn, desc)
    vim.keymap.set('n', lhs, fn, { desc = desc })
  end

  map('<leader>tt', function()
    neotest.run.run()
  end, '[T]est nearest')
  map('<leader>tf', function()
    neotest.run.run(vim.fn.expand '%')
  end, '[T]est [F]ile')
  map('<leader>ts', function()
    neotest.run.run(require('custom.venv').root() or vim.fn.getcwd())
  end, '[T]est [S]uite')
  map('<leader>td', function()
    neotest.run.run { strategy = 'dap' }
  end, '[T]est [D]ebug nearest')
  map('<leader>tx', function()
    neotest.run.stop()
  end, '[T]est stop')
  map('<leader>to', function()
    neotest.output.open { enter = true }
  end, '[T]est [O]utput')
  map('<leader>tp', function()
    neotest.output_panel.toggle()
  end, '[T]est [P]anel')
  map('<leader>tS', function()
    neotest.summary.toggle()
  end, '[T]est [S]ummary')
end

return M
