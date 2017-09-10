# Dotfiles

My collection of configuration options, plugins, and other stuff that make my daily life easier.
I like to keep my setup quite minimal and simple, this README is intended only as an installation
reference to get started, comments can be found within dotfiles.

## Tools

**[ITerm3](https://www.iterm2.com/version3.html)**

- [Install instructions](https://www.iterm2.com/version3.html)
- [Color presets](https://github.com/mbadolato/iTerm2-Color-Schemes)
- [Powerline fonts](https://github.com/powerline/fonts)

**[Homebrew](https://brew.sh)**

    $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    $ brew install tmux zsh gnupg wget ripgrep fzf reattach-to-user-namespace
    $ brew install vim --with-python3 --with-luajit
    $ brew install lastpass-cli --with-pinentry
    $ /usr/local/opt/fzf/install

**[asdf](https://github.com/asdf-vm/asdf)**

    $ git clone https://github.com/asdf-vm/asdf.git ~/.asdf

## Commands

    $ defaults write com.apple.finder AppleShowAllFiles YES
    $ defaults write com.apple.dock autohide-delay -float 1000; killall Dock

## Clone

    $ git clone https://github.com/sidofc/dotfiles ~/.dotfiles
    $ cd ~/.dotfiles
    $ ./bin/dot ln! # forcefully symlink into ~
