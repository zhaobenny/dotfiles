codex () {
    bunx @openai/codex "$@"
}


# Local helper script aliases
#
# Keep machine-specific aliases in ~/.bash_aliases.local so they stay local to
# this machine and out of version control.
if [ -f "$HOME/.bash_aliases.local" ]; then
    . "$HOME/.bash_aliases.local"
fi
