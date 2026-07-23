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

# Source scripts
source ~/vulkan/setup-env.sh

# Starship prompt
eval "$(starship init zsh)"


# Added by Antigravity CLI installer
export PATH="/home/bibinuz/.local/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/bibinuz/.lmstudio/bin"
# End of LM Studio CLI section

# Minecraft Server Shortcuts
alias minecraft-start="systemctl --user start minecraft"
alias minecraft-stop="systemctl --user stop minecraft"
alias minecraft-status="systemctl --user status minecraft"
alias minecraft-console="tmux -L minecraft attach -t minecraft"
