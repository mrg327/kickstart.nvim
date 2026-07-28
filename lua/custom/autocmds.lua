local M = {}

function M.setup()
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
      vim.hl.on_yank()
    end,
  })

  local markdown_save_timers = {}
  local markdown_autosave = vim.api.nvim_create_augroup('markdown-autosave', { clear = true })
  vim.api.nvim_create_autocmd('CursorHold', {
    group = markdown_autosave,
    pattern = '*.md',
    callback = function(event)
      local buffer = event.buf
      if not vim.bo[buffer].modified then
        return
      end

      local timer = markdown_save_timers[buffer]
      if not timer then
        timer = vim.uv.new_timer()
        markdown_save_timers[buffer] = timer
      end
      timer:stop()
      timer:start(750, 0, vim.schedule_wrap(function()
        if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].modified then
          vim.api.nvim_buf_call(buffer, function()
            vim.cmd 'silent! write'
          end)
        end
      end))
    end,
    desc = 'Auto-save Markdown files after inactivity',
  })
  vim.api.nvim_create_autocmd('BufWipeout', {
    group = markdown_autosave,
    callback = function(event)
      local timer = markdown_save_timers[event.buf]
      if timer then
        timer:stop()
        timer:close()
        markdown_save_timers[event.buf] = nil
      end
    end,
  })

  local views = vim.api.nvim_create_augroup('persistent-views', { clear = true })
  local function is_file_buffer(buffer)
    return vim.bo[buffer].buftype == '' and vim.api.nvim_buf_get_name(buffer) ~= ''
  end

  vim.api.nvim_create_autocmd('BufWritePost', {
    group = views,
    callback = function(event)
      if is_file_buffer(event.buf) then
        vim.cmd 'mkview'
      end
    end,
  })
  vim.api.nvim_create_autocmd('BufWinEnter', {
    group = views,
    callback = function(event)
      if is_file_buffer(event.buf) then
        vim.cmd 'silent! loadview'
      end
    end,
  })
end

return M
