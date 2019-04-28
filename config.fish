## SETTINGS
set fish_greeting
set -U  fish_user_paths            ~/bin $HOME/.asdf/shims
set -gx FZF_DEFAULT_OPTS           '--height=50% --min-height=15 --reverse'
set -gx FZF_DEFAULT_COMMAND        'rg --files --no-ignore-vcs --hidden'
set -gx FZF_CTRL_T_COMMAND         $FZF_DEFAULT_COMMAND
set -gx EVENT_NOKQUEUE             1
set -gx EDITOR                     nvim
set -gx HOMEBREW_FORCE_VENDOR_RUBY 1
set -gx GPG_TTY                    (tty)
set -gx ASDF_DIR                   /usr/local/opt/asdf

## ABBREVIATIONS
# gpg-agent
abbr gpg-add "echo | gpg -s >/dev/null ^&1"

# config files
abbr aa  "$EDITOR ~/.config/alacritty/alacritty.yml"
abbr vv  "$EDITOR ~/.config/nvim/init.vim"
abbr tt  "$EDITOR ~/.tmux.conf"
abbr zz  "$EDITOR ~/.config/fish/config.fish"
abbr ff  "$EDITOR ~/.config/fish/config.fish"
abbr zx  ". ~/.config/fish/config.fish"
abbr ks  "kp --tcp"

# python
abbr py  'python'

# crystal
abbr cr  'crystal'

# git
abbr g.  'git add .'
abbr gc  'git commit -m'
abbr gco 'git checkout'
abbr gd  'git diff'
abbr gf  'git fetch'
abbr gl  'git log'
abbr gmt 'git mergetool'
abbr gp  'git push'
abbr gpl 'git pull'
abbr gg  'git status'
abbr gs  'git stash'
abbr gsp 'git stash pop'

# vim
abbr v   "$EDITOR ."
abbr vd  "set -x VIM_DEV 1; and $EDITOR .; and set -e VIM_DEV"
abbr vip "$EDITOR +PlugInstall +qall"
abbr vup "$EDITOR +PlugUpdate"
abbr vcp "$EDITOR +PlugClean +qall"

## FUNCTIONS
function fp --description 'Search your $PATH'
  set -l loc (echo $PATH | tr ' ' '\n' | eval "fzf $FZF_DEFAULT_OPTS --header='[find:path]'")

  if test (count $loc) = 1
    set -l cmd (rg --files -L $loc | rev | cut -d'/' -f1 | rev | tr ' ' '\n' | eval "fzf $FZF_DEFAULT_OPTS --header='[find:exe] => $loc'")
    if test (count $cmd) = 1
      echo $cmd
    else
      fp
    end
  end
end

function kp --description "Kill processes"
  set -l __kp__pid ''

  if contains -- '--tcp' $argv
    set __kp__pid (lsof -Pwni tcp | sed 1d | eval "fzf $FZF_DEFAULT_OPTS -m --header='[kill:tcp]'" | awk '{print $2}')
  else
    set __kp__pid (ps -ef | sed 1d | eval "fzf $FZF_DEFAULT_OPTS -m --header='[kill:process]'" | awk '{print $2}')
  end

  if test "x$__kp__pid" != "x"
    if test "x$argv[1]" != "x"
      echo $__kp__pid | xargs kill $argv[1]
    else
      echo $__kp__pid | xargs kill -9
    end
    kp
  end
end

function bip --description "Install brew plugins"
  set -l inst (brew search | eval "fzf $FZF_DEFAULT_OPTS -m --header='[brew:install]'")

  if not test (count $inst) = 0
    for prog in $inst
      brew install "$prog"
    end
  end
end

function bcp --description "Remove brew plugins"
  set -l inst (brew leaves | eval "fzf $FZF_DEFAULT_OPTS -m --header='[brew:uninstall]'")

  if not test (count $inst) = 0
    for prog in $inst
      brew uninstall "$prog"
    end
  end
end

function pbclear --description "Provide functionality to clear from the pasteboard (the Clipboard) from command line"
  if test (which pbcopy)
    echo '' | pbcopy
  end
end

function fish_prompt --description 'Write out the prompt'
  switch $status
    case 0   ; set_color green
    case 127 ; set_color yellow
    case '*' ; set_color red
  end
  echo -n '• '
  set_color blue
  echo -n (prompt_pwd)

  if test (git rev-parse --git-dir 2>/dev/null)
    set_color yellow
    echo -n " on "
    set_color green
    echo -n (git status | head -1 | string split ' ')[-1]

    if test -n (git status -s)
      set_color magenta
    else
      set_color green
    end

    echo -n ' ⚑'
  end

  set_color yellow
  echo ' ❯ '
end

function gcb --description "delete git branches"
  set delete_mode '-d'

  if contains -- '--force' $argv
    set force_label ':force'
    set delete_mode '-D'
  end

  set -l branches_to_delete (git branch | sed -E 's/^[* ] //g' | fzf -m --header="[git:branch:delete$force_label]")

  if test -n "$branches_to_delete"
    git branch $delete_mode $branches_to_delete
  end
end

## SOURCES
[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish
[ -f /usr/local/opt/asdf/asdf/asdf.fish ]; and source /usr/local/opt/asdf/asdf.fish

## GPG
gpg-agent --daemon --no-grab >/dev/null ^&1

## TMUX
if status --is-interactive
and command -s tmux >/dev/null
and not set -q TMUX
  exec tmux new -A -s (whoami)
end
