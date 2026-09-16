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

  -- STM32 debugging (Nucleo boards, on-board ST-LINK)
  --
  -- OpenOCD bridges the ST-LINK to a GDB server on localhost:3333, and
  -- gdb-multiarch's built-in DAP mode bridges that server to nvim-dap.
  -- Start OpenOCD with <leader>ds, then pick the attach configuration.
  -- Configurable via:
  --   STM32_DEVICE   – OpenOCD target family file, e.g. stm32f4x (default), stm32h7x
  local openocd_device = os.getenv 'STM32_DEVICE' or 'stm32f4x'
  local openocd_cmd = {
    'openocd',
    '-s',
    '/usr/share/openocd/scripts',
    '-f',
    'interface/stlink.cfg',
    '-f',
    ('target/%s.cfg'):format(openocd_device),
  }

  dap.adapters.gdb = {
    type = 'executable',
    command = 'gdb-multiarch',
    args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
  }

  vim.keymap.set('n', '<leader>ds', function()
    -- A project Makefile knows its board, so prefer `make openocd` and only
    -- fall back to the STM32_DEVICE environment variable outside a project.
    local cmd = openocd_cmd
    if vim.fn.filereadable 'Makefile' == 1 then
      cmd = { vim.fn.exepath 'make' ~= '' and vim.fn.exepath 'make' or 'make', 'openocd' }
    end
    vim.cmd 'botright 12split'
    if vim.fn.has 'nvim-0.11' == 1 then
      vim.fn.jobstart(cmd, { term = true })
    else
      vim.fn.termopen(cmd)
    end
    vim.cmd 'wincmd p'
  end, { desc = '[D]ebug: start OpenOCD [S]erver' })

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
      name = 'Debug STM32 (attach to OpenOCD :3333)',
      type = 'gdb',
      request = 'attach',
      program = function()
        return vim.fn.input('Path to firmware ELF: ', vim.fn.getcwd() .. '/build/firmware.elf', 'file')
      end,
      target = 'localhost:3333',
      cwd = '${workspaceFolder}',
    },
  }

  dap.configurations.c = dap.configurations.cpp

  -- ============================================================
  -- STM32 Build & Flash Pipeline (mirrors CubeIDE workflow)
  --
  -- Commands run through vim.system, so their output never touches the
  -- terminal under nvim. Failures land in quickfix; success is a notify.
  -- Everything is asynchronous, so the ~20 s first HAL build does not
  -- freeze the editor. Steps chain through callbacks, not return values.
  -- ============================================================
  local make_bin = vim.fn.exepath 'make'
  if make_bin == '' then
    make_bin = 'make'
  end

  --- Run cmd in the current directory; call on_done(ok) when it exits.
  local function run(cmd, on_done)
    vim.system(cmd, { cwd = vim.fn.getcwd(), text = true }, function(r)
      vim.schedule(function()
        local out = vim.trim((r.stdout or '') .. (r.stderr or ''))
        if r.code ~= 0 then
          vim.fn.setqflist({}, ' ', {
            title = table.concat(cmd, ' '),
            lines = vim.split(out, '\n'),
            efm = '%f:%l:%c: %t%*[^:]: %m,%f:%l: %t%*[^:]: %m,%-G%.%#',
          })
          vim.cmd.copen()
          vim.notify(cmd[1] .. ' failed (exit ' .. r.code .. ')', vim.log.levels.ERROR)
        else
          -- Success: show only the tail (size report for make, verify line
          -- for st-flash), not every compiler command line.
          local lines = vim.split(out, '\n')
          local tail = table.concat(vim.list_slice(lines, math.max(1, #lines - 2)), '\n')
          vim.notify(tail ~= '' and tail or (cmd[1] .. ' ok'), vim.log.levels.INFO)
        end
        if on_done then
          on_done(r.code == 0)
        end
      end)
    end)
  end

  local function stm32_build(on_done)
    vim.notify('Building STM32 firmware...', vim.log.levels.INFO)
    run({ make_bin }, on_done)
  end

  local function firmware_path(ext)
    ext = ext or '.bin'
    local cwd = vim.fn.getcwd()
    for _, p in ipairs {
      cwd .. '/build/firmware' .. ext,
      cwd .. '/firmware' .. ext,
      cwd .. '/' .. vim.fn.expand '%:t:r' .. ext,
    } do
      if vim.fn.filereadable(p) == 1 then
        return p
      end
    end
    return vim.fn.input('Firmware path: ', '', 'file')
  end

  local function stm32_flash(on_done)
    local path = firmware_path()
    if path == '' then
      if on_done then
        on_done(false)
      end
      return
    end
    vim.notify('Flashing ' .. vim.fn.fnamemodify(path, ':.') .. ' via ST-LINK...', vim.log.levels.INFO)
    run({ 'st-flash', '--reset', 'write', path, '0x08000000' }, on_done)
  end

  -- Build + Flash
  vim.keymap.set('n', '<leader>bf', function()
    stm32_build(function(ok)
      if ok then
        stm32_flash(function(flashed)
          if flashed then
            vim.notify('Flash succeeded. <leader>dc to debug.', vim.log.levels.INFO)
          end
        end)
      end
    end)
  end, { desc = '[B]uild & [F]lash STM32' })

  -- Build + Flash + Debug (full CubeIDE-like pipeline)
  vim.keymap.set('n', '<leader>bd', function()
    stm32_build(function(ok)
      if ok then
        stm32_flash(function(flashed)
          if flashed then
            require('dap').continue()
          end
        end)
      end
    end)
  end, { desc = '[B]uild, [F]lash & [D]ebug STM32' })

  -- Just build (incremental)
  vim.keymap.set('n', '<leader>bm', function()
    stm32_build()
  end, { desc = '[B]uild STM32 firmware with [M]ake' })

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
