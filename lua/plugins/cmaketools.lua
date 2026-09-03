local M = {}

function M.setup()
  require('cmake-tools').setup {
    build_type = 'Debug',
    config_dir_build_subdir = false,
    cmake_options = {},
    keymaps = {
      build = '<leader>b',
      configure = '<leader>bc',
      options = '<leader>bo',
      binary_path = '<leader>bb',
    },
  }

  -- Auto-detect CMakeLists.txt and set up cmake-tools filetype
  vim.api.nvim_create_autocmd('BufReadPost', {
    group = vim.api.nvim_create_augroup('cmaketools-autodetect', { clear = true }),
    pattern = { 'CMakeLists.txt' },
    callback = function(event)
      -- Set cmake-tools as the filetype for CMake files
      if vim.bo[event.buf].filetype == 'cmake' then
        vim.bo[event.buf].filetype = 'cmaketools'
      end
    end,
  })
end

return M
