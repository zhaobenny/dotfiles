# benny's dotfiles

Run `./install.sh` for first-time setup or to install new packages. 

On NixOS, install Stow and the desired tools through Nix first. The script
skips package, Bun, and zoxide installation and only links the dotfiles and skills.
Clone this repository to `~/dotfiles` for automatic updates.

Dotfiles auto-update from git periodically.

Machine-specific shell helpers live in `~/.bash_aliases.local` and stay untracked.

Agent skills live in `.agents/skills` and are installed into the shared Agent Skills location plus Claude Code's personal skills directory.
