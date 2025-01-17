return { -- Collection of various small independent plugins/modules
      'echasnovski/mini.nvim',
      config = function()
        -- Better Around/Inside textobjects
        --
        -- Examples:
        --  - va)  - [V]isually select [A]round [)]paren
        --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
        --  - ci'  - [C]hange [I]nside [']quote
        -- require('mini.ai').setup { n_lines = 500 }

        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        --
        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        -- - sd'   - [S]urround [D]elete [']quotes
        -- - sr)'  - [S]urround [R]eplace [)] [']
        -- require('mini.surround').setup()

        -- Add mini pairs for autopairing of (), [], {}, '', '', <>
        require('mini.pairs').setup()

        -- Use MiniGit for git related actions
        -- require('mini.git').setup()
        -- -- Set custom keymaps for git actions
        -- -- - gp   - [G]it [A]dd [U]pdates
        -- vim.keymap.set('n', '<leader>gau', function()
        --   vim.cmd 'Git add -u'
        -- end, { desc = '[G]it [A]dd [U]pdates' })
        -- -- - gp   - [G]it [C]ommit
        -- vim.keymap.set('n', '<leader>gc', function()
        --   vim.cmd 'Git commit'
        -- end, { desc = '[G]it [C]ommit' })
        -- -- - gp   - [G]it [P]ull
        -- vim.keymap.set('n', '<leader>gp', function()
        --   vim.cmd 'Git pull'
        -- end, { desc = '[G]it [P]ull' })
        -- -- - gpsh - [G]it [P]ush
        -- vim.keymap.set('n', '<leader>gpsh', function()
        --   vim.cmd 'Git push'
        -- end, { desc = '[G]it [P]ush' })
        -- -- - gs   - [G]it [S]tatus
        -- vim.keymap.set('n', '<leader>gs', function()
        --   vim.cmd 'Git status'
        -- end, { desc = '[G]it [S]tatus' })

        -- Simple and easy statusline.
        --  You could remove this setup call if you don't like it,
        --  and try some other statusline plugin
        local statusline = require 'mini.statusline'
        -- set use_icons to true if you have a Nerd Font
        statusline.setup { use_icons = vim.g.have_nerd_font }

        -- You can configure sections in the statusline by overriding their
        -- default behavior. For example, here we set the section for
        -- cursor location to LINE:COLUMN
        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function()
          return '%2l:%-2v'
        end

        -- ... and there is more!
        --  Check out: https://github.com/echasnovski/mini.nvim
      end,
    }
