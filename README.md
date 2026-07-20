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

The first startup installs the packages declared in `lua/custom/packages.lua`.
Update them from Neovim with:

```lua
:lua vim.pack.update()
```

Review the generated update buffer, write it to confirm the update, and commit
the resulting `nvim-pack-lock.json`.

## Host-specific settings

`lua/custom/environment.lua` resolves a file named after the host, falling back
to `lua/default.lua`. Host files may set `python`, `shell`, `llm_addr`, and
`obsidian_loc`. Keep machine-specific paths out of shared plugin modules.
