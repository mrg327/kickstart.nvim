local M = {}

function M.setup()
  -- Better Around/Inside textobjects
  --
  -- Examples:
  --  - va)  - [V]isually select [A]round [)]paren
  --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
  --  - ci'  - [C]hange [I]nside [']quote
  require('mini.ai').setup { n_lines = 500 }

  -- Add/delete/replace surroundings (brackets, quotes, etc.)
  --
  -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
  -- - sd'   - [S]urround [D]elete [']quotes
  -- - sr)'  - [S]urround [R]eplace [)] [']
  require('mini.surround').setup()

  require('mini.align').setup()

  -- Add mini pairs for autopairing of (), [], {}, '', '', <>
  require('mini.pairs').setup()

  -- Add mini files for easy file browsing and creation
  require('mini.files').setup()
  vim.keymap.set('n', '<leader>of', function()
    MiniFiles.open()
  end, { desc = 'Open [O]pen [F]ile Browser' })
  local set_cwd = function()
    local fs_entry = MiniFiles.get_fs_entry()
    if fs_entry == nil then
      return vim.notify 'Cursor is not on valid entry'
    end

    local target_dir
    if fs_entry.fs_type == 'directory' then
      target_dir = fs_entry.path
    else
      target_dir = vim.fs.dirname(fs_entry.path)
    end

    vim.fn.chdir(target_dir)
    vim.notify('Changed directory to: ' .. target_dir)
  end

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
      local buf_id = args.data.buf_id
      vim.keymap.set('n', 'cd', set_cwd, { buffer = buf_id, desc = 'Change directory' })
    end,
  })

  -- require('mini.operators').setup()
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
end

return M
