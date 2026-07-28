local M = {}

function M.setup()
  local dap = require 'dap'
  local dapui = require 'dapui'
  local dap_python = require 'dap-python'

  dapui.setup {}
  require('nvim-dap-virtual-text').setup { commented = true }
  dap_python.setup 'python'

  vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DiagnosticSignError' })
  vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DiagnosticSignError' })
  vim.fn.sign_define('DapStopped', { text = '', texthl = 'DiagnosticSignWarn', linehl = 'Visual', numhl = 'DiagnosticSignWarn' })

  dap.listeners.after.event_initialized.dapui_config = dapui.open
  vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = '[D]ebug [B]reakpoint' })
  vim.keymap.set('n', '<leader>dc', dap.continue, { desc = '[D]ebug [C]ontinue' })
  vim.keymap.set('n', '<leader>do', dap.step_over, { desc = '[D]ebug Step [O]ver' })
  vim.keymap.set('n', '<leader>di', dap.step_into, { desc = '[D]ebug Step [I]nto' })
  vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = '[D]ebug Step [O]ut' })
  vim.keymap.set('n', '<leader>dq', dap.terminate, { desc = '[D]ebug [Q]uit' })
  vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = '[D]ebug [U]I' })
  vim.keymap.set('n', '<leader>dt', function()
    dap_python.test_method()
  end, { desc = '[D]ebug nearest [T]est' })
  vim.keymap.set('n', '<leader>dm', function()
    dap_python.test_class()
  end, { desc = '[D]ebug test class ([M]ethod group)' })
end

return M
