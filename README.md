# Dotfiles

My collection of configuration options, plugins, and other stuff that make my daily life easier.
I like to keep my setup quite minimal and simple, this README is intended only as an installation
reference to get started, comments can be found within dotfiles.

## [Homebrew](https://brew.sh)

    $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    $ brew install fish fzf autojump tmux neovim wget reattach-to-user-namespace
    $ brew install lastpass-cli --with-pinentry

**vim-plug**

The `neovim` setup uses [vim plug](https://github.com/junegunn/vim-plug#neovim), please see install instructions for respective OS.

## [alacritty](https://github.com/jwilm/alacritty)

    $ brew tap mscharley/homebrew
    $ brew install alacritty --HEAD

To update:

    $ brew reinstall alacritty
    $ cp -R /usr/local/opt/alacritty/Applications/Alacritty.app /Applications/


## [asdf](https://github.com/asdf-vm/asdf)

    $ git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    $ asdf plugin-add python
    $ asdf plugin-add ruby
    $ asdf plugin-add crystal
    $ asdf install python 3.6.2
    $ asdf install ruby 3.5.0
    $ asdf install crystal 0.24.0
    $ gem install bundler pry
    $ pip install ptpython
    $ asdf reshim python
    $ asdf reshim ruby

## Setup

    $ defaults write com.apple.finder AppleShowAllFiles YES
    $ defaults write com.apple.dock autohide-delay -float 1000; killall Dock
    $ git clone https://github.com/sidofc/dotfiles
    $ ./dotfiles/bin/setup
