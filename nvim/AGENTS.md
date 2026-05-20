# Read Before Modify

## References Websites

- https://neovim.io/doc/ (official docs)
- https://github.com/neovim/neovim (github src)

## Project Notes

- Keep LSP bootstrap in `lua/config/lsp.lua`; individual server configuration already lives in `lsp/*.lua`, so do not split `lua/config/lsp.lua` into extra submodules unless explicitly requested.
