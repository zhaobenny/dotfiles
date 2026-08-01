# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Add a directory to PATH if it exists and isn't already present.
path_prepend_if_exists() {
    [ -d "$1" ] || return
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1:$PATH" ;;
    esac
}

# Return a file's mtime across GNU/BSD `stat`.
file_mtime() {
    [ -e "$1" ] || return 1

    if stat -c %Y "$1" >/dev/null 2>&1; then
        stat -c %Y "$1"
    else
        stat -f %m "$1"
    fi
}

append_prompt_command() {
    local command="$1"

    if [[ -z "${PROMPT_COMMAND:-}" ]]; then
        PROMPT_COMMAND="$command"
    elif [[ "$PROMPT_COMMAND" != *"$command"* ]]; then
        PROMPT_COMMAND="${PROMPT_COMMAND}"$'\n'"$command"
    fi
}

append_debug_trap() {
    local command="$1"
    local current_trap

    current_trap=$(trap -p DEBUG)
    current_trap=${current_trap#trap -- \'}
    current_trap=${current_trap%\' DEBUG}

    if [[ -z "$current_trap" ]]; then
        trap "$command" DEBUG
    elif [[ "$current_trap" != *"$command"* ]]; then
        trap "${current_trap}"$'\n'"$command" DEBUG
    fi
}

# Ensure Go is on PATH
path_prepend_if_exists "/usr/local/go/bin"
path_prepend_if_exists "$HOME/go/bin"
path_prepend_if_exists "$HOME/.local/bin"

# Bun (needed in non-interactive shells too)
if [ -d "$HOME/.bun/bin" ]; then
    export BUN_INSTALL="$HOME/.bun"
    path_prepend_if_exists "$BUN_INSTALL/bin"
fi

export PATH

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=9999
HISTFILESIZE=9999

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if command -v dircolors >/dev/null 2>&1; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

if ls --color=auto >/dev/null 2>&1; then
    alias ls='ls --color=auto'
elif ls -G >/dev/null 2>&1; then
    alias ls='ls -G'
fi

if printf 'x\n' | grep --color=auto -q 'x' >/dev/null 2>&1; then
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Use bat for interactive file viewing while scripts continue to use cat.
if command -v batcat >/dev/null 2>&1; then
    alias cat='batcat --paging=auto'
elif command -v bat >/dev/null 2>&1; then
    alias cat='bat --paging=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Use zoxide as a smarter `cd`, while retaining normal Bash path completion.
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash --cmd cd)"
    complete -o nospace -F _cd cd
fi

# Enable fuzzy history, file, and directory selection when fzf is installed.
if command -v fzf >/dev/null 2>&1; then
    [ -r /usr/share/doc/fzf/examples/key-bindings.bash ] && . /usr/share/doc/fzf/examples/key-bindings.bash
fi

# Prevent file overwrite on stdout redirection
# Use `>|` to force redirection to an existing file
set -o noclobber

# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2

## SMARTER TAB-COMPLETION (Readline bindings) ##

# Perform file completion in a case insensitive fashion
bind "set completion-ignore-case on"

# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"

# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"

# Immediately add a trailing slash when autocompleting symlinks to directories
bind "set mark-symlinked-directories on"


## SANE HISTORY DEFAULTS ##

# Save multi-line commands as one command
shopt -s cmdhist

# Record each line as it gets issued and set the tab title without clobbering
# other prompt hooks.
save_history_and_set_title() {
    history -a
    printf '\033]0;%s\007' "${PWD##*/}"
}
append_prompt_command "save_history_and_set_title"


# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
HISTTIMEFORMAT='%F %T '

# Enable incremental history search with up/down arrows (also Readline goodness)
# Learn more about this here: http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

## BETTER DIRECTORY NAVIGATION ##

# Prepend cd to directory names automatically
shopt -s autocd 2> /dev/null
# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null

export PATH="$PATH:/usr/local/bin"
export AWS_PROFILE=org

# Lazy-load Node tooling and let npm fall back to pnpm.
export NVM_DIR="$HOME/.nvm"
if [[ -d "$NVM_DIR" ]]; then
    _load_nvm() { [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; }
    nvm() { unset -f nvm; _load_nvm; nvm "$@"; }
    node() { unset -f node; _load_nvm; command node "$@"; }
    npx() { unset -f npx; _load_nvm; command npx "$@"; }
    npm() {
        unset -f npm
        _load_nvm
        if type -P pnpm >/dev/null 2>&1; then
            command pnpm "$@"
        else
            command npm "$@"
        fi
    }
fi

# --- WINDOWS TERMINAL TITLE CONFIGURATION ---

# Function to safely handle command titles (fixes quote issues)
function set_win_title() {
  printf "\033]0;%s\007" "$BASH_COMMAND"
}

# 1. When a command is running, use the function above without replacing
# any existing DEBUG trap handlers.
append_debug_trap "set_win_title"

# --- AUTO-UPDATE DOTFILES ---
# Updates dotfiles from git and restows, runs in background with 24-hour throttle
_update_dotfiles() {
    local dotfiles_dir="$HOME/dotfiles"
    local stamp_file="$dotfiles_dir/.last_update"
    local lock_dir="$dotfiles_dir/.last_update.lock"
    local log_file="$dotfiles_dir/.last_update.log"
    local throttle_seconds=86400  # 24 hours
    local now
    local stamp_mtime

    # Skip if not a git repo or stow not installed
    [[ -d "$dotfiles_dir/.git" ]] || return
    command -v git &>/dev/null || return
    command -v stow &>/dev/null || return

    # Throttle: skip if updated recently (use file mtime)
    now=$(date +%s)
    if [[ -f "$stamp_file" ]]; then
        stamp_mtime=$(file_mtime "$stamp_file" 2>/dev/null || echo 0)
        if (( now - stamp_mtime < throttle_seconds )); then
            return
        fi
    fi

    # Run update in background
    (
        mkdir "$lock_dir" 2>/dev/null || exit 0
        trap 'rmdir "$lock_dir"' EXIT
        cd "$dotfiles_dir" || exit

        {
            printf '[%s] starting dotfiles update\n' "$(date '+%Y-%m-%dT%H:%M:%S%z')"
            if git pull --quiet && stow --target="$HOME" --restow .; then
                touch "$stamp_file"
                printf '[%s] dotfiles update succeeded\n' "$(date '+%Y-%m-%dT%H:%M:%S%z')"
            else
                printf '[%s] dotfiles update failed\n' "$(date '+%Y-%m-%dT%H:%M:%S%z')"
                exit 1
            fi
        } >>"$log_file" 2>&1
    ) &
    disown
}
_update_dotfiles


path_prepend_if_exists "$HOME/bin"
export PATH

# Keep machine-specific paths and secrets in ~/.bashrc.local so they stay
# local to this host, the same way ~/.bash_aliases.local works for aliases.
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi
