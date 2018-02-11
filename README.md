# Dotfiles

My collection of configuration options, plugins, and other stuff that make my daily life easier.
I like to keep my setup quite minimal and simple, this README is intended only as an installation
reference to get started, comments can be found within dotfiles.

## [ITerm3](https://www.iterm2.com/version3.html)

- [Install instructions](https://www.iterm2.com/version3.html)
- [Color presets](https://github.com/mbadolato/iTerm2-Color-Schemes)
- [Powerline fonts](https://github.com/powerline/fonts)

## [Homebrew](https://brew.sh)

    $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    $ brew install fish fzf autojump tmux neovim wget reattach-to-user-namespace
    $ brew install lastpass-cli --with-pinentry

## Setup

    $ defaults write com.apple.finder AppleShowAllFiles YES
    $ defaults write com.apple.dock autohide-delay -float 1000; killall Dock
    $ git clone https://github.com/sidofc/dotfiles
    $ ./dotfiles/bin/setup
