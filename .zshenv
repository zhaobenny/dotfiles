# Paths needed by both interactive and non-interactive zsh.
for dir in /usr/local/go/bin "$HOME/go/bin" "$HOME/.local/bin" "$HOME/.bun/bin" "$HOME/bin"; do
    [[ -d "$dir" ]] && path=($dir ${path:#$dir})
done
[[ -d "$HOME/.bun/bin" ]] && export BUN_INSTALL="$HOME/.bun"
