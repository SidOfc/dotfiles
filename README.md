# Dotfiles

I like to keep my setup minimal and simple. It is based around the
following tools:

- [alacritty](https://github.com/alacritty/alacritty)
- [fish](https://fishshell.com)
- [tmux](https://github.com/tmux/tmux/wiki)
- [asdf](https://asdf-vm.com)
- [neovim](https://neovim.io)
- [vim-plug](https://github.com/junegunn/vim-plug)
- [fzf](https://github.com/junegunn/fzf)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [autojump](https://github.com/wting/autojump)
- [gnupg](https://www.gnupg.org)

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
