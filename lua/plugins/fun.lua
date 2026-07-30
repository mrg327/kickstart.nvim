--[[

    Cute / gamified / aesthetic plugins.

    Everything "for fun" lives here so it is easy to enable or disable in one
    place. This module is self-contained: it installs (via vim.pack) *and*
    configures only the features that are switched on below.

      * Set `M.enabled = false` to turn the whole lot off.
      * Flip an individual entry in `features` to false to drop just that one.

    Disabled plugins are never downloaded, loaded, or configured, and their
    keymaps are not registered.

--]]

local M = {}

-- Master switch for all the fun. Set to false to disable everything below.
M.enabled = true

-- Per-plugin toggles. Flip any to false to disable just that plugin.
local features = {
  modes = true, -- colour the cursorline by the current mode
  tiny_inline_diagnostic = true, -- pretty inline diagnostic bubbles
}

local sources = {
  modes = 'https://github.com/mvllow/modes.nvim',
  tiny_inline_diagnostic = 'https://github.com/rachartier/tiny-inline-diagnostic.nvim',
}

local configure = {
  modes = function()
    require('modes').setup {}
  end,

  tiny_inline_diagnostic = function()
    -- Turn off the default virtual text so the two don't overlap.
    vim.diagnostic.config { virtual_text = false }
    require('tiny-inline-diagnostic').setup {}
  end,
}

function M.setup()
  if not M.enabled then
    return
  end

  local to_install = {}
  for name, on in pairs(features) do
    if on then
      table.insert(to_install, { src = sources[name] })
    end
  end

  if #to_install == 0 then
    return
  end

  vim.pack.add(to_install, { confirm = false, load = true })

  for name, on in pairs(features) do
    if on then
      configure[name]()
    end
  end
end

return M
