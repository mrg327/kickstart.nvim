local M = {}

function M.setup()
  require('nvim-treesitter').setup()
  local unavailable_languages = {}
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('UserTreesitter', { clear = true }),
    callback = function(event)
      local buffer = event.buf
      if vim.bo[buffer].buftype ~= '' then
        return
      end

      local language = vim.treesitter.language.get_lang(event.match) or event.match
      if vim.treesitter.highlighter.active[buffer] then
        return
      end

      local function notify_unavailable(error_message)
        if unavailable_languages[language] then
          return
        end
        unavailable_languages[language] = true
        vim.notify(('Treesitter unavailable for %s: %s'):format(event.match, error_message), vim.log.levels.WARN, { title = 'Treesitter' })
      end

      local parser_ok, parser_error = pcall(vim.treesitter.get_parser, buffer, language)
      if not parser_ok then
        notify_unavailable(parser_error)
        return
      end
      local started, start_error = pcall(vim.treesitter.start, buffer, language)
      if not started then
        notify_unavailable(start_error)
        return
      end
    end,
  })
end

return M
