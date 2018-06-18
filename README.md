# Dotfiles

My collection of configuration options, plugins, and other stuff that make my daily life easier.
I like to keep my setup quite minimal and simple, this README is intended only as an installation
reference to get started, comments can be found within dotfiles.

## [Homebrew](https://brew.sh)

    $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    $ brew install fish fzf autojump tmux neovim wget reattach-to-user-namespace
    $ brew install lastpass-cli --with-pinentry gnupg pinentry-mac

**vim-plug**

The `neovim` setup uses [vim plug](https://github.com/junegunn/vim-plug#neovim), please see install instructions for respective OS.

## [alacritty](https://github.com/jwilm/alacritty)

    $ brew tap mscharley/homebrew
    $ brew install alacritty --HEAD

To update:

    $ brew reinstall alacritty
    $ cp -R /usr/local/opt/alacritty/Applications/Alacritty.app /Applications/

## GPG

Add the following to `~/.gnupg/gpg-agent.conf`:

    pinentry-program /usr/local/bin/pinentry-mac

## [asdf](https://github.com/asdf-vm/asdf)

    $ git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    $ asdf plugin-add python
    $ asdf plugin-add ruby
    $ asdf plugin-add crystal
    $ asdf install python 3.6.2
    $ asdf install ruby 2.6.0
    $ asdf install crystal 0.24.1
    $ asdf install rust 1.26.2
    $ pip install ptpython

## Setup

    $ defaults write com.apple.finder AppleShowAllFiles YES
    $ defaults write com.apple.dock autohide-delay -float 1000; killall Dock
    $ git clone https://github.com/sidofc/dotfiles
    $ ./dotfiles/bin/setup

**OSX**

Your terminfo will definitely be outdated (time of writing: April, 2018). This will cause vim/nvim not to change cursor shapes in insert / replace / normal mode.
Inside the `.config/fish/functions` folder a `update_terminfo` command downloads a terminfo file from the alacritty repository. See [this comment](https://github.com/jwilm/alacritty/issues/736#issuecomment-344439826) for more information.

    $ update_terminfo
