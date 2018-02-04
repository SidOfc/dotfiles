# Options {{{
  setopt extended_glob
  setopt prompt_subst
  setopt auto_cd

  stty -ixon
# }}}

# Zplug {{{
  if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update
  else
    source ~/.zplug/init.zsh
  fi

  zplug "zplug/zplug",                       lazy:1

  zplug "plugins/shrink-path",               from:"oh-my-zsh"
  zplug "plugins/autojump",                  from:"oh-my-zsh"
  zplug "lib/history",                       from:"oh-my-zsh"
  zplug "zdharma/fast-syntax-highlighting",  defer:3
  zplug "zsh-users/zsh-autosuggestions",     defer:3

  zplug "BurntSushi/ripgrep",                defer:3, from:"gh-r", as:"command", use:"*darwin*", rename-to:"rg"
  zplug "junegunn/fzf-bin",                  defer:3, from:"gh-r", as:"command", use:"*darwin*", rename-to:"fzf"
  zplug "asdf-vm/asdf",                      defer:3

  if ! zplug check --verbose; then
      printf "Install? [y/N]: "
      if read -q; then
          echo; zplug install
      else
          echo
      fi
  fi

  zplug load
# }}}

# Exports and (auto)loading {{{
  export ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[green]%}"
  export ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
  export ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[magenta]%} ⚑"
  export ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%} ⚑"
  export FZF_DEFAULT_OPTS="--height=50% --min-height=15 --reverse"
  export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export LPS_DEFAULT_USERNAME="sidneyliebrand@gmail.com"
  export PROMPT='%{$fg_bold[blue]%}$(shrink_path -f)%{$fg_bold[yellow]%}$(git_prompt_info)%{$fg_bold[yellow]%} ❯ %{$reset_color%}'
  export RPROMPT='%(?..%{$fg_bold[red]%}%? ↵%{$reset_color%})'
  export EDITOR='vim'
  export EVENT_NOKQUEUE=1
  export PATH="$HOME/bin:$HOME/.asdf/shims:$PATH"
  export VIM_DEV=0

  export BASE16_SHELL=$HOME/.config/base16-shell/
  [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

  # set autoload path
  fpath=(~/zsh "${fpath[@]}")

  # move cursor to end of line after history search completion
  autoload -U history-search-end cani vmc vmi lps kp fp cani bip bup bcp tmuxify utils ll

  # every time we load .zshrc, ditch duplicate path entries
  typeset -U PATH fpath
# }}}

# Colors {{{
  if [[ $TERM == xterm ]]
  then
    TERM=xterm-256color
  fi
# }}}

# Aliasses {{{
  # prefer nvim over vim when present
  if type nvim > /dev/null 2>&1; then
    alias vim='nvim'
  fi

  alias cr='crystal'
  alias ga="git add ."
  alias gc="git commit -m ${1}"
  alias gd="git diff"
  alias gdt="git difftool"
  alias gmt="git mergetool"
  alias gp="git push ${1} ${2}"
  alias gco="git checkout ${1} ${2}"
  alias gpl="git pull ${1} ${2}"
  alias grb="git rebase ${1} ${2}"
  alias gs="git status"
  alias la="ls -al"
  alias lf="ls -al | grep ${1}"
  alias ls="ls -Gl"
  alias tt="$EDITOR ~/.tmux.conf"
  alias u="utils"
  alias v="vim ."
  alias vcp="vim +PlugClean +qall"
  alias vip="vim +PlugInstall +qall"
  alias vup="vim +PlugUpdate"
  alias vv="$EDITOR ~/.vimrc"
  alias zx="source ~/.zshrc"
  alias zz="$EDITOR ~/.zshrc"
# }}}

# Keybindings {{{
  bindkey '^e' autosuggest-accept

  # search history using already written command string
  zle -N history-beginning-search-backward-end history-search-end
  bindkey "^[[A" history-beginning-search-backward-end

  zle -N history-beginning-search-forward-end history-search-end
  bindkey "^[[B" history-beginning-search-forward-end
# }}}

### toggle vim in "dev" mode (see .vimrc: $VIM_DEV)
# allows me to easily load plugins from local directory rather than ~/.vim/bundle
vdm() {
  if [[ "$VIM_DEV" == "1" ]] then
    export VIM_DEV=0
  else
    export VIM_DEV=1
  fi

  echo "vdm: $VIM_DEV"
}

tmuxify
