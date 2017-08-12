# install the following packages:
#
# - `homebrew`                   => https://brew.sh/
# - `gnupg`                      => brew install gnupg
# - `tmux`                       => brew install tmux
# - `vim`                        => brew install vim --with-python3 --with-luajit
# - `wget`                       => brew install wget
# - `reattach-to-user-namespace` => brew install reattach-to-user-namespace
# - `autojump`                   => brew install autojump
# - `zsh-syntax-highlighting`    => brew install zsh-syntax-highlighting
# - `asdf`                       => https://github.com/asdf-vm/asdf
# - `asdf-ruby`                  => https://github.com/asdf-vm/asdf-ruby
# - `asdf-nodejs`                => https://github.com/asdf-vm/asdf-nodejs
# - `asdf-rust`                  => https://github.com/code-lever/asdf-rust
# - `asdf-crystal`               => https://github.com/marciogm/asdf-crystal
# - `base16-shell`               => https://github.com/chriskempson/base16-shell
#
# run shell commands:
#
# ### asdf reshims
#
# - `asdf reshim ruby <version>`
# - `asdf reshim nodejs <version>`
# - `asdf reshim rust <version>`
# - `asdf reshim crystal <version>`
#
# ### mac system commands
#
# - `defaults write com.apple.finder AppleShowAllFiles YES`
# - `defaults write com.apple.dock autohide-delay -float 1000; killall Dock`

# plugin list
plugins=(tmux git brew osx colorize github ruby bundler extract shrink-path)

# zsh tmux plugin settings
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOSTART_ONCE=false
ZSH_TMUX_FIXTERM_WITHOUT_256COLOR="xterm"
ZSH_TMUX_FIXTERM_WITHOUT_256COLOR="xterm-256-color"

# ssh connection stuff
[[ -n "$SSH_CLIENT" ]] || DEFAULT_USER="$(whoami)"

# load zsh
export ZSH_THEME="kphoen"
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

setopt RM_STAR_WAIT        # sanity check for accidental 'rm *'
setopt interactivecomments # bash comments in prompt
setopt prompt_subst        # enable prompt substitution

# exports
export BASE16_SHELL=$HOME/.config/base16-shell/
export PROMPT='[%{$fg[red]%}%n%{$reset_color%} at %{$fg[blue]%}$(shrink_path -f)%{$reset_color%}$(git_prompt_info)] %# '
export EDITOR='vim'

# various aliasses
alias config="/usr/bin/git --work-tree=$HOME"
alias ag='ag -i --path-to-ignore ~/.agignore'
alias cr='crystal'
alias cani='caniuse'
alias aa="$EDITOR ~/.asdfrc"
alias zz="$EDITOR ~/.zshrc"
alias zx="source ~/.zshrc"
alias vv="$EDITOR ~/.vimrc"
alias vip="vim +PluginInstall +qall"
alias vup="vim +PluginUpdate"
alias vcp="vim + PluginClean +qall"
alias tt="$EDITOR ~/.tmux.conf"
alias tr="tmux source-file ~/.tmux.conf"
alias v="$EDITOR ."

# set terminal to 256-color mode when possible
if [[ $TERM == xterm ]]; then
  TERM=xterm-256color
fi

# sourcing
[ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
. /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. /usr/local/etc/profile.d/autojump.sh
. $HOME/.asdf/asdf.sh
