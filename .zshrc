# Use the Homebrew installation already on PATH, including user-owned installs.
if [[ $(uname -s) == Darwin ]] && (( $+commands[brew] )); then
    eval "$(brew shellenv)"
fi

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=9999
SAVEHIST=9999
setopt append_history hist_ignore_space hist_ignore_dups interactive_comments auto_cd no_clobber

autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
PROMPT='%n@%m:%~%# '

if ls --color=auto >/dev/null 2>&1; then
    alias ls='ls --color=auto'
elif ls -G >/dev/null 2>&1; then
    alias ls='ls -G'
fi
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
if (( $+commands[batcat] )); then
    alias cat='batcat --paging=auto'
elif (( $+commands[bat] )); then
    alias cat='bat --paging=auto'
fi
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases
(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd cd)"
if (( $+commands[fzf] )); then
    if [[ -r /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
        source /usr/share/doc/fzf/examples/key-bindings.zsh
    elif [[ -n ${HOMEBREW_PREFIX:-} && -r $HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh ]]; then
        source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
    fi
fi
export AWS_PROFILE=org
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
