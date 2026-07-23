# Dotfiles

Personal configuration files for my macOS development environment.
All tools share a consistent **Catppuccin Mocha** dark theme.

## Structure

```
.config/
├── bash/           # Bash shell configuration
├── btop/           # System resource monitor
├── fish/           # Fish shell with fzf, zoxide, fisher
├── ghostty/        # GPU-accelerated terminal + GLSL cursor shaders
├── git/            # Global git ignore rules
├── karabiner/      # macOS keyboard remapping (Ctrl+hjkl → arrows)
├── nvim/           # Neovim (primary editor)
├── tmux/           # Terminal multiplexer
├── yazi/           # Terminal file manager
├── zed/            # Zed editor configuration
├── zsh/            # Z shell with zinit, fzf, zoxide, starship
└── starship.toml   # Cross-shell prompt (Catppuccin Mocha)
```

## Environment

| Tool | Role | Highlights |
|------|------|------------|
| **Neovim** | Primary editor | lazy.nvim, 9 LSP servers, blink.cmp, snacks.nvim (dashboard/keys/toggles), heirline statusline, flash, oil, gitsigns, telescope |
| **Zed** | Secondary editor | vim mode, opencode agent, codex-acp, claude-acp |
| **Ghostty** | Terminal emulator | 0.85 opacity, hidden titlebar, 4 custom GLSL cursor shaders (sweep/tail/warp/ripple) |
| **tmux** | Terminal multiplexer | `` ` `` prefix, vi keys, Catppuccin Mocha status bar, allow-passthrough for Yazi images |
| **Fish** | Daily shell | Vi-mode, fzf integration, zoxide, fippuccin theme, custom greeting |
| **Zsh** | Fallback shell | zinit, fast-syntax-highlighting, zsh-autosuggestions, fzf-tab, zoxide |
| **Bash** | Compatibility | Vi-mode, custom prompt, dircolors |
| **Karabiner** | Keyboard customizer | Ctrl+h/j/k/l → arrow keys (system-wide) |
| **Yazi** | File manager | Catppuccin Mocha flavor, image preview |
| **btop** | System monitor | Transparent background, vim-style keys |

## Fonts

- **JetBrains Mono** — Primary coding font
- **Maple Mono NF CN** — CJK / icon fallback

## Key Bindings

All shells use **Vi-mode**. System-wide:

| Key | Action |
|-----|--------|
| `Ctrl-h/j/k/l` | Arrow keys (via Karabiner) |
| `Ctrl-p / Ctrl-n` | History search |
| `Alt-h / Alt-l` | Move word left/right |
| `Ctrl-a / Ctrl-e` | Line start/end |
| `` ` `` | tmux prefix |

## Installation

```bash
git clone https://github.com/D1376/dotfiles.git ~/.config
```

Nvim plugins, LSP servers, tmux plugins, and shell completions may need
additional setup — refer to each directory for its requirements.
