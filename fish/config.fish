# fish/config.fish
# @author deng
# since 2024 2025 2026

# Cute startup greeting.
function _fish_greeting
    set -l pink (set_color --bold magenta)
    set -l blue (set_color 89B4FA)
    set -l off (set_color normal)
    printf '%s%s %sNyaa~ %sterminal ready! %s(^._.^)~%s <3\n' \
        $pink '🐾' $pink $blue $pink $off
end
set -g fish_greeting (_fish_greeting)

# Default editor.
set -gx EDITOR nvim
set -gx VISUAL $EDITOR

# Homebrew environment.
if test -x /opt/homebrew/bin/brew; and not set -q HOMEBREW_PREFIX
    eval (/opt/homebrew/bin/brew shellenv)
end

# User and package paths.
fish_add_path --global \
    $HOME/.local/bin \
    $HOME/.opencode/bin \
    /opt/homebrew/opt/openjdk@21/bin
fish_add_path --global --append $HOME/.lmstudio/bin

# fzf defaults.
if command -q rg
    set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --glob '!.git'"
end
set -gx FZF_DEFAULT_OPTS "--height=40% --layout=reverse --border --cycle --preview-window=wrap"

# Keep non-interactive shells lightweight.
status is-interactive; or return

# Theme.
fish_config theme choose fippuccin

# Directory listing aliases.
if command -q eza
    alias l.="eza -a"
    alias ls="eza -F --sort=type --icons=always"
    alias ll="eza -aF --long --sort=type --icons=always"
    alias lt4="eza -lT -L4 --icons"
end

if command -q opencode
  alias oc="opencode"
end

# Small command shortcuts.
abbr --add --position command -- '~' 'cd ~'
alias ..="cd .."
alias c="clear"
alias ff="fastfetch"
alias vi="nvim"
alias vim="nvim"
alias gst="git status"
alias cfg="cd ~/.config"
alias cc="claude --dangerously-skip-permissions"
alias 哈吉米="cat"

# Vi mode and key bindings.
fish_vi_key_bindings

# Shell navigation shortcuts.
for mode in default insert
    bind --mode $mode ctrl-p history-search-backward
    bind --mode $mode ctrl-n history-search-forward
    bind --mode $mode ctrl-a beginning-of-line
    bind --mode $mode ctrl-e end-of-line
end

bind --mode insert ctrl-f accept-autosuggestion
bind --mode default alt-w kill-selection
bind --mode visual alt-w kill-selection

# Smarter cd.
if command -q zoxide
    zoxide init --cmd cd fish | source
end

# Prompt.
if command -q starship
    starship init fish | source
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
