local M = {}

function M.setup()
  require('which-key').setup {
    icons = {
      mappings = vim.g.have_nerd_font,
      keys = vim.g.have_nerd_font and {} or {
        Up = '<Up> ',
        Down = '<Down> ',
        Left = '<Left> ',
        Right = '<Right> ',
        C = '<C-…> ',
        M = '<M-…> ',
        D = '<D-…> ',
        S = '<S-…> ',
        CR = '<CR> ',
        Esc = '<Esc> ',
        ScrollWheelDown = '<ScrollWheelDown> ',
        ScrollWheelUp = '<ScrollWheelUp> ',
        NL = '<NL> ',
        BS = '<BS> ',
        Space = '<Space> ',
        Tab = '<Tab> ',
        F1 = '<F1>',
        F2 = '<F2>',
        F3 = '<F3>',
        F4 = '<F4>',
        F5 = '<F5>',
        F6 = '<F6>',
        F7 = '<F7>',
        F8 = '<F8>',
      },
    },
    spec = {
      { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
      { '<leader>d', group = '[D]ebug' },
      { '<leader>p', group = 'LS[P]' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>g', group = '[G]it' },
      { '<leader>o', group = '[O]pen' },
      { '<leader>q', group = '[Q]uickfix' },
      { '<leader>u', group = 'Config[u]re Options' },
      { '<leader>uf', group = '[F]olds' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>t', group = '[T]est' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>F', group = '[F]un' },
    },
  }
end

return M
