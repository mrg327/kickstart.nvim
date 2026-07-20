return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'echasnovski/mini.nvim' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        file_types = { 'markdown' },
        completions = { lsp = { enabled = true } },
    },
}
