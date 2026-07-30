--[[

     _   _      _         _                 _
    | \ | | ___(_)_ __   | |__   ___   ___ | |_
    |  \| |/ _ \ | '_ \  | '_ \ / _ \ / _ \| __|
    | |\  |  __/ | |_) | | |_) | (_) | (_) | |_
    |_| \_|\___|_| .__/  |_.__/ \___/ \___/ \__|
                 |_|

    Welcome to the control panel.

    This is not a distribution. It is a small, native-Neovim-first setup:
      options   -> editor defaults and host-specific settings
      keymaps   -> navigation, windows, and the occasional undo tree
      autocmds  -> useful background magic
      packages  -> vim.pack and the plugins that still earn their keep

    The order below matters: leaders first, packages last.
    When something feels mysterious, follow the require into lua/config/ or
    lua/plugins/.

    May your motions be precise and your :w be intentional.

--]]

require('config.options').setup()
require('config.keymaps').setup()
require('config.autocmds').setup()
require('plugins').setup()
