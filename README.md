# Dotfiles

My collection of configuration options, plugins, and other stuff that make my daily life easier.
I like to keep my setup quite minimal and simple, there is a ~200 line ruby script called `dot` which will do the following:

- Install homebrew plugins defined in the constant `HOMEBREW_PACKAGES` which can have install options through `HOMEBREW_INSTALL_OPTIONS`.
- Install asdf plugins defined in `ASDF_PLUGINS`, versions can be supplied in the format of a `asdf list-all [language]` entry.
- Run some `defaults write` commands that make finder show `.dotfiles` as well and to hide the dock unless it is hovered over for a very long time.
- Symlink the actual dotfiles to their destinations, see the `MAP` constant for how this works.
- Install vim-plug and also install and update vim plugins.

## Link dotfiles

    $ git clone https://github.com/sidofc/dotfiles
    $ ./dotfiles/bin/dot
