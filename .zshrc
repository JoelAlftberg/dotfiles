# JoelAlftberg .zshrc config

# https://donottrack.sh/
export DO_NOT_TRACK=1

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Load command suggestions
autoload -Uz compinit
compinit

# Use default emacs keymap
bindkey -e

# Keybinds
bindkey "^[[1;5C" 	forward-word
bindkey "^[[1;5D" 	backward-word
bindkey "^[[H" 		beginning-of-line
bindkey "^[[F" 		end-of-line
bindkey "^[[3~" 	delete-char
bindkey "^[[3;5~"	kill-word		

# Use zoxide for faster directory traversal
eval "$(zoxide init zsh)"

# Jump to any repo in ~/dev faster
repo() {
  cd $(find ~/dev -mindepth 3 -maxdepth 3 -type d | fzf)
}

# Display git branch
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '( %b)'

# Custom prompt
setopt PROMPT_SUBST
PROMPT='%F{blue}joel%f%F{blue}󰣛 %f%F{green}%2~%f%F{yellow} ${vcs_info_msg_0_}%f '

alias editrc="vi ~/.zshrc"
alias reloadrc="source ~/.zshrc"
alias vi="nvim"
alias vim="nvim"
alias getidf='. $HOME/.espressif/tools/activate_idf_v6.0.1.sh && export PATH="$HOME/.espressif/tools/qemu-xtensa/esp_develop_9.2.2_20250817/qemu/bin:$PATH"'
