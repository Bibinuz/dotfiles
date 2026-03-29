eval "$(starship init zsh)"

HISTFILE=~/.history
HISTSIZE=1000
SAVEHIST=5000

setopt inc_append_history

autoload -U compinit && compinit

alias ls="exa --icons="always" -l"
alias lsa="exa --icons="always" -la"

export VK_LOADER_DEBUG=info,warn,error

source ~/VulkanSDK/default/setup-env.sh
