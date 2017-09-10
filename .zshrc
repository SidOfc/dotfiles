# zplug specifics
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "themes/kphoen",                          from:"oh-my-zsh"
zplug "lib/history",                            from:"oh-my-zsh"
zplug "plugins/shrink-path",                    from:"oh-my-zsh"
zplug "plugins/autojump",                       from:"oh-my-zsh"
zplug "zsh-users/zsh-autosuggestions",          defer:2
zplug "zsh-users/zsh-syntax-highlighting",      defer:2

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# autostart tmux session if tmux available
case $- in *i*); [ -z "$TMUX" ] && exec tmux -2; esac

# set terminal to 256-color mode in xterm
if [[ $TERM == xterm ]]; then; TERM=xterm-256color; fi

# path adjustment, upon reloading zshrc, filter duplicate path entries
export PATH="$HOME/bin:$PATH"
typeset -U PATH

# additional FZF options
export FZF_DEFAULT_OPTS="--height=50% --min-height=15 --reverse"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# lps command default username
export LPS_DEFAULT_USERNAME="sidneyliebrand@gmail.com"

# enable prompt substitution (path / branch info per entered command etc..)
# and implicit CD (e.g. $ ~ == $ cd ~)
setopt prompt_subst
setopt auto_cd

# exports
export PROMPT='%{$fg[blue]%}$(shrink_path -f)%{$fg[yellow]%}$(git_prompt_info)%{$fg[yellow]%} ❯ '
export EDITOR='vim'
export EVENT_NOKQUEUE=1

# aliasses
alias cr='crystal'
alias zz="$EDITOR ~/.zshrc"
alias zx="source ~/.zshrc"
alias vv="$EDITOR ~/.vimrc"
alias vip="vim +PluginInstall +qall"
alias vup="vim +PluginUpdate"
alias vcp="vim +PluginClean +qall"
alias tt="$EDITOR ~/.tmux.conf"
alias v="$EDITOR ."
alias la="ls -al"
alias lf="ls -al | grep ${1}"
alias ga="git add ."
alias gc="git commit -m ${1}"
alias gs="git status"
alias gd="git diff"
alias gdt="git difftool"
alias gmt="git mergetool"
alias gpl="git pull ${1} ${2}"
alias grb="git rebase ${1} ${2}"
alias gp="git push ${1} ${2}"

# keybindings
bindkey '^e' autosuggest-accept

# sourcing


# caniuse for quick access to global support list
# also runs the `caniuse` command if installed
cani() {
  local feats=$(ciu | sort -rn | eval "fzf ${FZF_DEFAULT_OPTS} -m --ansi --header='[caniuse:features]'" | sed -e 's/^.*%\ *//g' | sed -e 's/   .*//g')

  if [[ $feats ]]; then
    for feat in $(echo $feats)
    do if [[ $feat ]]; then; caniuse $feat; fi
    done
  fi
}

# vim-like CtrlP in zsh.
fzf-ctrlp-open-in-vim() {
  local out=$(eval $FZF_DEFAULT_COMMAND | eval "fzf ${FZF_DEFAULT_OPTS} --exit-0 --header='[vim:open]'")

  if [ -f "$out" ]; then
    $EDITOR "$out" < /dev/tty
  fi

  zle reset-prompt
}

### ASDF
# install multiple languages at once, async
# mnemonic [V]ersion [M]anager [I]nstall
vmi() {
  local lang=${1}

  if [[ -z $lang ]]; then
    lang=$(asdf plugin-list-all | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[asdf:install]'")
  fi

  if [[ $lang ]]; then
    for lng in $(echo $lang); do
      if [[ -z $(asdf plugin-list | rg $lng) ]]; then
        asdf plugin-add $lng
      else
        asdf plugin-update $lng >/dev/null 2>/dev/null &!
      fi

      for version in $(asdf list-all $lng | sort -nrk1,1 | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[asdf:${lng}:install]'")
      do asdf install $lng $version
      done
    done
  fi
}

# uninstall multiple languages at once, async
# mnemonic [V]ersion [M]anager [C]lean
vmc() {
  local lang=${1}

  if [[ -z $lang ]]; then
    lang=$(asdf plugin-list | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[asdf:clean]'")
  fi

  if [[ $lang ]]; then
    for lng in $(echo $lang); do
      for version in $(asdf list $lng | sort -nrk1,1 | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[asdf:${lng}:clean]'")
      do asdf uninstall $lng $version >/dev/null 2>/dev/null &!
      done
    done
  fi
}

### BREW FUNCTIONS

# mnemonic [B]rew [I]nstall [P]lugin
bip() {
  local inst=$(brew search | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[brew:install]'")

  if [[ $inst ]]; then
    for prog in $(echo $inst)
    do brew install $prog
    done
  fi
}

# update multiple packages at once, async
# mnemonic [B]rew [U]pdate [P]lugin
bup() {
  local upd=$(brew leaves | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[brew:update]'")

  if [[ $upd ]]; then
    for prog in $(echo $upd)
    do brew upgrade $prog >/dev/null 2>/dev/null &!
    done
  fi

  return 0
}

# uninstall multiple packages at once, async
# mnemonic [B]rew [C]lean [P]lugin (e.g. uninstall)
bcp() {
  local uninst=$(brew leaves | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[brew:clean]'")

  if [[ $uninst ]]; then
    for prog in $(echo $uninst)
    do brew uninstall $prog >/dev/null 2>/dev/null &!
    done
  fi

  return 0
}

### LASTPASS
lps() {
  local uname=$LPS_DEFAULT_USERNAME
  local loggedin=1

  if [[ $(lpass status | grep '^Not logged in') ]]; then
    loggedin=""

    if [[ -z $uname ]]; then
      echo -n "Lastpass username: "
      read uname
    fi


    if [[ -n $uname ]]; then
      lpass login --trust $uname > /dev/null 2>/dev/null
    fi
  fi

  if [ $? -eq 0 ]; then
    local selected=$(lpass ls -l | lpfmt | eval "fzf ${FZF_DEFAULT_OPTS} --ansi --header='[lastpass:copy]'" | awk '{$1=$2=""}1')

    if [[ $selected ]]; then
      lpass show -cp $(echo $selected)
    fi
  fi
}

### GENERAL FUNCTIONS

# mnemonic: [F]ind [P]ath
fp() {
  echo $PATH | sed -e $'s/:/\\\n/g' | eval "fzf ${FZF_DEFAULT_OPTS} --header='[find:path]' >/dev/null"
}

# mnemonic: [K]ill [P]rocess
kp() {
  local pid=$(ps -ef | sed 1d | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[kill:process]'" | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# mnemonic: [K]ill [S]erver
ks() {
  local pid=$(lsof -Pwni tcp | sed 1d | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[kill:tcp]'" | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

utils() {
  local helptxt="bcp    [brew:clean]
bip    [brew:install]
bup    [brew:update]
cani   [caniuse:features]
fp     [find:path]
kp     [kill:path]
ks     [kill:tcp]
lps    [lastpass:copy]
vmc    [asdf:clean]
vmi    [asdf:install]
cr     [alias]              crystal
ga     [alias]              git add .
gc     [alias]              git commit -m \${1}
gd     [alias]              git diff
gdt    [alias]              git difftool
gmt    [alias]              git mergetool
gp     [alias]              git push   \${1} \${2}
gpl    [alias]              git pull   \${1} \${2}
grb    [alias]              git rebase \${1} \${2}
gs     [alias]              git status
la     [alias]              ls -al
lf     [alias]              ls -al | grep \${1}
tt     [alias]              $EDITOR ~/.tmux.conf
v      [alias]              $EDITOR .
vcp    [alias]              vim +PluginClean +qall
vip    [alias]              vim +PluginInstall +qall
vup    [alias]              vim +PluginUpdate
vv     [alias]              $EDITOR ~/.vimrc
zx     [alias]              source ~/.zshrc
zz     [alias]              $EDITOR ~/.zshrc"

  local cmd=$(echo $helptxt | eval "fzf ${FZF_DEFAULT_OPTS} --header='[utils:show]'" | awk '{print $1}')

  if [[ -n $cmd ]]; then
    eval ${cmd}
  fi
}

alias u="utils"

zle     -N   fzf-ctrlp-open-in-vim
bindkey '^P' fzf-ctrlp-open-in-vim

source $HOME/.asdf/asdf.sh
source ~/.fzf.zsh
