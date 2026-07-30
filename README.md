# Neovim configuration

This configuration targets Neovim 0.12 and uses its native `vim.pack` package
manager. Plugin revisions are tracked in `nvim-pack-lock.json`.

## Requirements

- Neovim 0.12 or newer
- `git`, `make`, `rg`, and a C compiler
- `tree-sitter` CLI for compiling and updating Treesitter parsers
- A Nerd Font for icons

Language servers and formatters are installed by Mason. The current setup
manages Pyright, Ruff, Cucumber Language Server, HTML Language Server,
ast-grep, Lua Language Server, and Stylua.

## Package management

The first startup installs the packages declared in `lua/plugins/init.lua`.
Update them from Neovim with:

```lua
:lua vim.pack.update()
```

Review the generated update buffer, write it to confirm the update, and commit
the resulting `nvim-pack-lock.json`.

## Configuration layout

Editor-wide options, mappings, autocommands, and virtual-environment discovery
live in `lua/config/`. Plugin declarations and setup modules live in
`lua/plugins/`, with LuaSnip definitions in `lua/plugins/snippets/`. Keep
machine-specific paths out of this shared configuration.
