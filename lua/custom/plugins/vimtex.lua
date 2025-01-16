return {
  "lervag/vimtex",
  lazy = false,     -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = "general"
    -- Tell VimTeX to use Okular for viewing PDFs:
    vim.g.vimtex_view_general_viewer = 'okular'
    -- Specify a compiler VimTeX uses latexmk as the default compiler backend. If you use it, which is
    -- strongly recommended, you probably don't need to configure anything. If you
    -- want another compiler backend, you can change it as follows. The list of
    -- supported backends and further explanation is provided in the documentation,
    -- see ":help vimtex-compiler". method (default is latexmk; here we use latexrun):
    -- vim.g.vimtex_compiler_method = 'latexrun'
  end
}
