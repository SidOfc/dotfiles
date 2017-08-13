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
export PROMPT='[%{$fg[red]%}%n%{$reset_color%} at %{$fg[blue]%}$(shrink_path -f)%{$reset_color%}$(git_prompt_info)] %# '
export EDITOR='vim'

# various aliasses
alias ag='ag -i --path-to-ignore ~/.agignore'
alias cr='crystal'
alias zz="$EDITOR ~/.zshrc"
alias zx="source ~/.zshrc"
alias vv="$EDITOR ~/.vimrc"
alias vip="vim +PluginInstall +qall"
alias vup="vim +PluginUpdate"
alias vcp="vim +PluginClean +qall"
alias tt="$EDITOR ~/.tmux.conf"
alias tr="tmux source-file ~/.tmux.conf"
alias v="$EDITOR ."

# set terminal to 256-color mode when possible
if [[ $TERM == xterm ]]; then
  TERM=xterm-256color
fi

# sourcing
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/etc/profile.d/autojump.sh
source $HOME/.asdf/asdf.sh
