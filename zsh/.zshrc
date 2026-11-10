# Colors
autoload -U colors && colors
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# History
HISTFILE=~/.history
HISTSIZE=10000
SAVEHIST=10000

setopt appendhistory
setopt inc_append_history
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_space

# Completion
autoload -U compinit && compinit
zstyle ':completion:*' menu select

# Aliases
alias ls="exa --icons=always -l"
alias lsa="exa --icons=always -la"
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'

# Starship prompt
eval "$(starship init zsh)"



. "$HOME/.local/bin/env"
