# Dotfiles

I like to keep my setup minimal and simple. It is based around the
following tools:

- [alacritty](https://github.com/alacritty/alacritty) >= 4.2
- [fish](https://fishshell.com) >= 3.0
- [tmux](https://github.com/tmux/tmux/wiki) >= 2.7
- [asdf](https://asdf-vm.com) >= 0.7.6
- [neovim](https://neovim.io) >= 0.4.2
- [vim-plug](https://github.com/junegunn/vim-plug) latest
- [fzf](https://github.com/junegunn/fzf) >- 0.20
- [ripgrep](https://github.com/BurntSushi/ripgrep) >= 11.0.2
- [autojump](https://github.com/wting/autojump) >= 22.5.3
- [gnupg](https://www.gnupg.org) >= 2.2.19

## `bin/setup`

The included `bin/setup` script will perform the following tasks:

- **ask** what you want to do for each symlink in `$SYMLINKS`.
- **ask** to check presence of each path/tool in `$TOOLS`.
- **ask** to install and update vim plugins if `vim-plug` and `neovim` are installed.
- **ask** to set `defaults` if on macOS.

## Installation

    $ git clone https://github.com/sidofc/dotfiles
    $ sudo chmod +x ./dotfiles/bin/setup
    $ ./dotfiles/bin/setup
