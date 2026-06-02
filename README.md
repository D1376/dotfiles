# Dotfiles

Personal configuration files for my development environment on macOS.

## Overview

This repository contains the configuration for my terminal-based workflow, centered around Neovim, tmux, and modern CLI tools. All tools share a consistent **Catppuccin Mocha** dark theme.

## Directory Structure

```
.config/
├── bash/           # Bash shell configuration
├── btop/           # System resource monitor
├── fcitx5/         # Input method framework (Rime)
├── fish/           # Fish shell configuration
├── ghostty/        # GPU-accelerated terminal emulator
├── git/            # Global gitignore rules
├── htop/           # Process viewer
├── mole/           # macOS system cleaner (logs only)
├── nvim/           # Neovim editor configuration
├── opencode/       # AI coding assistant (TUI)
├── raycast/        # macOS productivity launcher
├── raycast-x/      # Raycast (alternate profile)
├── tmux/           # Terminal multiplexer
├── yazi/           # Terminal file manager
├── zed/            # Code editor
├── zsh/            # Zsh shell configuration
└── starship.toml   # Cross-shell prompt configuration
```

## Tools

### Editors & IDEs

- **Neovim** — Primary editor. Configured with lazy.nvim, LSP servers (Python, C++, TypeScript, Lua, Java, etc.), Treesitter, Telescope, and 20+ plugins.
- **Zed** — Secondary editor. Vim mode enabled, integrated with AI agent servers.

### Terminal & Shell

- **Ghostty** — GPU-accelerated terminal with custom GLSL cursor shaders.
- **tmux** — Terminal multiplexer with 13 plugins (continuum, resurrect, fzf, yank, etc.). Prefix key: `` ` ``.
- **Fish / Zsh / Bash** — All configured with Vi-mode keybindings, fzf integration, and shared aliases (eza, nvim, git shortcuts).
- **Starship** — Minimal cross-shell prompt with Git status and language indicators.

### CLI Tools

- **yazi** — Terminal file manager with image preview support.
- **btop** — System monitor with Vim-style navigation.
- **htop** — Classic process viewer.

### Productivity

- **Raycast** — macOS launcher (Spotlight alternative) with installed extensions.
- **Fcitx5** — Input method framework with Rime engine for Chinese input.
- **OpenCode** — AI coding assistant with 19 custom skills.

## Key Bindings

All shells use **Vi-mode** as the default editing style. Common bindings:

| Key | Action |
|-----|--------|
| `Ctrl-p / Ctrl-n` | History search (up/down) |
| `Alt-h / Alt-l` | Move word left/right |
| `Ctrl-A / Ctrl-E` | Jump to line start/end |

## Fonts

- **JetBrains Mono** — Primary coding font
- **Maple Mono NF CN** — Fallback for CJK characters and icons

## Installation

Clone this repository to `~/.config`:

```bash
git clone <repo-url> ~/.config
```

Individual tool configs may require additional setup (plugin managers, LSP servers, etc.). Refer to each tool's directory for details.

## Excluded Files

The `.gitignore` excludes plugin directories, cache files, lock files, and sensitive configurations (e.g., `AGENTS.md`, `CLAUDE.md`, Raycast extensions).
