# Dotfiles

My collection of configuration options, plugins, and other stuff that make my daily life easier.
I like to keep my setup quite minimal and not too bloated (it probably is though :P).
The following will be a small guide to the initial setup.

# Programs

## 1.0 [ITerm3](https://www.iterm2.com/version3.html)

A replacement for macOS Terminal.app

### 1.1 Install

Follow instructions [here](https://www.iterm2.com/version3.html)

### 1.2 [Color presets](https://github.com/mbadolato/iTerm2-Color-Schemes)

    $ cd ~
    $ git clone https://github.com/mbadolato/iTerm2-Color-Schemes

Then, launch ITerm3 and open preferences (<kbd>cmd</kbd>+<kbd>,</kbd>) and navigate to _profiles_ > _colors_ > _color presets_ and press _import..._. In the finder window, navigate to ~/iTerm2-Color-Schemes/schemes and select them all.

### 1.3 [Powerline fonts](https://github.com/powerline/fonts)

    $ cd ~
    $ git clone https://github.com/powerline/fonts.git --depth=1
    $ cd fonts
    $ ./install.sh
    $ cd ..
    $ rm -rf fonts

## 2.0 [Homebrew](https://brew.sh)

The missing package manager for macOS

### 2.1 Install

    $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

### 2.2 Packages

Install additional packages / dependencies using [brew bundle](https://github.com/Homebrew/homebrew-bundle)

    $ brew install zsh zplug gnupg wget diff-so-fancy ripgrep
    $ brew install tmux reattach-to-user-namespace
    $ brew install vim --with-python3 --with-luajit
    $ brew install lastpass-cli --with-pinentry

After installing fzf, also run: `/usr/local/opt/fzf/install`

## 3.0 [asdf](https://github.com/asdf-vm/asdf)

A replacement for all version managers out there like [rvm](https://rvm.io/) or [nvm](https://github.com/creationix/nvm)

### 3.1 Install

At the time of writing, the current version is `0.3.0` - check upstream regularly!

    $ git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.3.0

### 3.2 Plugins

The following are additional "version managers" for different languages.

    $ asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
    $ asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    $ asdf plugin-add rust https://github.com/code-lever/asdf-rust
    $ asdf plugin-add crystal https://github.com/marciogm/asdf-crystal

# Commands

Optionally, run the following commands:

    $ defaults write com.apple.finder AppleShowAllFiles YES
    $ defaults write com.apple.dock autohide-delay -float 1000; killall Dock

# Finally

    $ cd ~
    $ git clone https://github.com/sidofc/dotfiles ./.dotfiles
    $ cd .dotfiles
    $ ./install -f # forcefully symlink into ~
    # after restarting shell, run `u` to list commands and aliasses defined in zshrc
    $ u
