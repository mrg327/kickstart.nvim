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

  -- C++ Debug Adapter (codelldb)
  dap.adapters.codelldb = {
    type = 'executable',
    command = vim.fn.exepath 'codelldb',
    args = { '--port', '0' },
  }

  -- OpenOCD adapter for STM32 via ST-LINK/V2.1 (Nucleo boards)
  --
  -- Launches OpenOCD on port 3333, then connects codelldb to it.
  -- Configurable via:
  --   STM32_DEVICE   – e.g. STM32F446RE, STM32H743VI (default: STM32F446RE)
  local openocd_device = vim.fn.getenv 'STM32_DEVICE' or 'stm32f4x'

  dap.adapters.openocd = {
    type = 'executable',
    command = vim.fn.exepath 'openocd' or 'openocd',
    args = {
      '-s', '/usr/share/openocd/scripts',
      '-f', 'interface/stlink.cfg',
      '-f', ('target/%s.cfg'):format(openocd_device),
    },
  }

  dap.configurations.cpp = {
    {
      name = 'Build & Debug',
      type = 'codelldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/build/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopAtFirstLine = true,
      simulateInput = false,
      showDebugOutput = true,
    },
    {
      name = 'Debug STM32 (OpenOCD + ST-LINK)',
      type = 'openocd',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to firmware ELF: ', vim.fn.getcwd() .. '/build/firmware.elf', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopAtFirstLine = false,
      showDebugOutput = true,
    },
  }

  dap.configurations.c = dap.configurations.cpp

  -- ============================================================
  -- STM32 Build & Flash Pipeline (mirrors CubeIDE workflow)
  -- ============================================================
  local make_bin = vim.fn.exepath 'make' or 'make'

  local function stm32_build()
    vim.notify('Building STM32 firmware...', vim.log.levels.INFO)
    local ok, code = os.execute(make_bin .. ' -C ' .. vim.fn.getcwd())
    return ok and code == 0
  end

  local function stm32_flash(ext)
    ext = ext or '.bin'
    local paths = {
      vim.fn.getcwd() .. '/build/firmware' .. ext,
      vim.fn.getcwd() .. '/firmware' .. ext,
      vim.fn.getcwd() .. '/' .. vim.fn.expand('%:t:r') .. ext,
    }
    local flash_path = nil
    for _, p in ipairs(paths) do
      if vim.fn.filereadable(p) == 1 then
        flash_path = p
        break
      end
    end
    if not flash_path then
      flash_path = vim.fn.input('Firmware path: ', '', 'file')
    end
    if flash_path == '' then return false end

    vim.notify('Flashing ' .. flash_path .. ' to STM32 via ST-LINK...', vim.log.levels.INFO)
    local cmd = ('st-flash write %%s 0x08000000'):format(flash_path)
    local ok, code = os.execute(cmd)
    return ok and code == 0
  end

  -- Build + Flash
  vim.keymap.set('n', '<leader>bf', function()
    if stm32_build() then
      if stm32_flash() then
        vim.notify('Flash succeeded. Press <leader>dB to debug.', vim.log.levels.OK)
      end
    end
  end, { desc = '[B]uild & [F]lash STM32' })

  -- Build + Flash + Debug (full CubeIDE-like pipeline)
  vim.keymap.set('n', '<leader>bd', function()
    if stm32_build() then
      if stm32_flash() then
        vim.schedule(function()
          require('dap').continue()
        end)
      end
    end
  end, { desc = '[B]uild, [F]lash & [D]ebug STM32' })

  -- Just build (incremental)
  vim.keymap.set('n', '<leader>br', function()
    vim.notify('Building...', vim.log.levels.INFO)
    os.execute(make_bin .. ' -C ' .. vim.fn.getcwd())
  end, { desc = '[B]uild STM32 firmware' })

  -- Flash only (no rebuild)
  vim.keymap.set('n', '<leader>bl', function()
    stm32_flash()
  end, { desc = '[B]urn flash only (no rebuild)' })

  vim.keymap.set('n', '<leader>dB', function()
    require('dap').run_last()
  end, { desc = '[D]ebug C++ program (build & launch)' })
  vim.keymap.set('n', '<leader>dr', function()
    dap.run({ startPause = false })
  end, { desc = '[D]ebug: [R]un without debugging' })
end

return M
