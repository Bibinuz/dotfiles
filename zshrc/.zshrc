eval "$(starship init zsh)"

HISTFILE=~/.history
HISTSIZE=1000
SAVEHIST=5000

setopt inc_append_history

autoload -U compinit && compinit

alias ls="exa -l"
