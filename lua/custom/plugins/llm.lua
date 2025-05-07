local response_format = 'Respond EXACTLY in this format:\n```$ftype\n<your code>\n```'

return {
  'nomnivore/ollama.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },

  -- All the user commands added by the plugin
  cmd = { 'Ollama', 'OllamaModel', 'OllamaServe', 'OllamaServeStop' },

  keys = {
    -- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
    {
      '<leader>oo',
      ":<c-u>lua require('ollama').prompt()<cr>",
      desc = 'ollama prompt',
      mode = { 'n', 'v' },
    },

    -- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
    {
      '<leader>oG',
      ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
      desc = 'ollama Generate Code',
      mode = { 'n', 'v' },
    },
  },

  ---@type Ollama.Config
  opts = {
    -- your configuration overrides
    url = ENV_PATHS['llm_addr'],
    model = 'llama3',
    prompts = {

      Comment_Code = {
        prompt = 'Modify this $ftype code in the following way: Add google-style docstrings to all functions, classes, and methods\n\n'
          .. response_format
          .. '\n\n```$ftype\n$sel```',
        action = 'replace',
      },
    },
  },
}
