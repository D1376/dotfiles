# config.fish
# @author deng
# since 2024 2025 2026

# Keep startup cheap for scripts, and put interactive-only setup below the guard.
set -g fish_greeting
set -gx EDITOR nvim
set -gx VISUAL $EDITOR

# Homebrew shellenv is only needed once per process tree.
if test -x /opt/homebrew/bin/brew; and not set -q HOMEBREW_PREFIX
    eval (/opt/homebrew/bin/brew shellenv)
end

# User tools first; GUI/app-specific fallbacks last.
fish_add_path --global \
    $HOME/.local/bin \
    $HOME/.opencode/bin \
    /opt/homebrew/opt/coreutils/libexec/gnubin \
    /opt/homebrew/opt/openjdk@21/bin
fish_add_path --global --append $HOME/.lmstudio/bin

# fzf defaults used by fzf.fish and manual fzf calls.
if command -q rg
    set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --glob '!.git'"
end
set -gx FZF_DEFAULT_OPTS "--height=40% --layout=reverse --border --cycle --preview-window=wrap"

status is-interactive; or return

# Interactive UI preferences.
set -g fish_cursor_default block
set -g fish_cursor_insert line
set -g fish_cursor_replace_one underscore
set -g fish_cursor_visual block

# Prefer eza when available, with portable ls fallbacks.
if command -q eza
    alias l.="eza -a"
    alias ls="eza -F --sort=type --icons=always"
    alias ll="eza -aF --long --sort=type --icons=always"
    alias lt4="eza -lT -L4 --icons"
else
    if command ls --color=auto -d . >/dev/null 2>&1
        alias ls="ls -F --color=auto"
        alias ll="ls -alhF --color=auto"
    else
        alias ls="ls -FG"
        alias ll="ls -alhFG"
    end
end

# Small command shortcuts.
abbr --add --position command -- ~ "cd ~"
alias ..="cd .."
alias c="clear"
alias ff="fastfetch"
alias vi="nvim"
alias vim="nvim"
alias gst="git status"
alias cfg="cd ~/.config"
alias cc="claude --dangerously-skip-permissions"
alias 哈吉米="cat"

# Set vi mode first, then reinstall plugin/user bindings that vi mode can reset.
fish_vi_key_bindings

if functions -q fzf_configure_bindings
    fzf_configure_bindings
end

for mode in default insert
    bind -M $mode \cp history-search-backward
    bind -M $mode \cn history-search-forward
    bind -M $mode \ca beginning-of-line
    bind -M $mode \ce end-of-line
end

bind -M insert \cf accept-autosuggestion
bind -M default \ew kill-selection
bind -M visual \ew kill-selection

# Prompt and directory-jump integrations.
if command -q zoxide
    zoxide init --cmd cd fish | source
end

if command -q starship
    starship init fish | source
end
